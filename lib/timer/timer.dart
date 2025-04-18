import 'dart:async';

import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/foreground_task/timer_task.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/colors.dart'; // Add this
import 'package:atloud/theme/theme.dart';
import 'package:atloud/timer/timer_picker_widget.dart';
import 'package:atloud/timer/timer_progress_painter.dart'; // Add this
import 'dart:math' as math; // Add this
import 'package:atloud/converters/string_to_duration.dart'; // Add this
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../shared/available_page.dart';
import '../sound/speaker.dart';

class _TimerPageState extends State<TimerPage> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  var _isTimerPage = true;

  final _speaker = Speaker();
  Duration? _startingTime;

  bool _isPickingTime = false;

  @override
  void initState() {
    _isTimerPage = widget.isTimerPage;
    ForegroundTaskStarter.startService(_timerTick);
    _loadUserPreferences().then((preferences) => _initPage(preferences));

    super.initState();
  }

  void _initPage(Map<String, dynamic> preferences) {
    if (_isTimerPage) {
      FlutterForegroundTask.sendDataToTask({...preferences, TimerTaskHandler.commandParameter: TimerTaskHandler.setTimerCommand});
    } else {
      FlutterForegroundTask.sendDataToTask({...preferences, TimerTaskHandler.commandParameter: TimerTaskHandler.setClockCommand});
    }
  }

  void _timerTick(Object data) {
    _taskDataListenable.value = data;
  }

  Future<Map<String, dynamic>> _loadUserPreferences() async {
    var screenLockValue = await UserDataStorage.screenLockValue();
    WakelockPlus.toggle(enable: screenLockValue);

    _startingTime = await UserDataStorage.startingTimerValue();

    return {
      TimerTaskHandler.startingTimeParameter: DurationToString.convert(_startingTime!),
      TimerTaskHandler.periodParameter: await UserDataStorage.periodValue(),
      TimerTaskHandler.continueAfterAlarmParameter: await UserDataStorage.continueAfterAlarmValue()
    };
  }

  void _switchPage() {
    setState(() {
      _isPickingTime = false;
      _isTimerPage = !_isTimerPage;
    });
    if (_isTimerPage) {
      UserDataStorage.storeLastVisitedPageValue(AvailablePage.timer);
    } else {
      UserDataStorage.storeLastVisitedPageValue(AvailablePage.clock);
    }
    _loadUserPreferences().then((preferences) => _initPage(preferences));
  }

  @override
  void dispose() {
    ForegroundTaskStarter.stopService();
    FlutterForegroundTask.removeTaskDataCallback(_timerTick);
    _taskDataListenable.dispose();
    super.dispose();
  }

  void _enterTimePickingMode() {
    setState(() {
      _isPickingTime = true;
    });
  }

  // Add this method inside _TimerPageState class
  Widget _buildMuteIcon() {
    // TODO: Implement actual mute logic and state
    bool isMuted = false; // Placeholder state
    return IconButton(
      icon: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up, // Example icons
        color: CustomColors.textColor.withOpacity(0.7),
        size: 30, // Adjust size as needed
      ),
      onPressed: () {
        // TODO: Implement toggle mute action
        // setState(() { isMuted = !isMuted; });
        print("Mute toggled"); // Placeholder action
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 0.0),
        child: Center(
          child: _isPickingTime
              ? TimePickerWidget(
                  initialTime: _startingTime ?? const Duration(),
                  onTimeSelected: (newTime) {
                    if (newTime != _startingTime) {
                      _startingTime = newTime;
                      UserDataStorage.storeStartingTimerValue(_startingTime!);
                      _loadUserPreferences().then((preferences) => _initPage(preferences));
                    }
                    setState(() {
                      _isPickingTime = false;
                    });
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Replace this Container:
                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 30.0),
                    //   child: ValueListenableBuilder(...)
                    // ),
                    // With this Expanded widget containing LayoutBuilder and ValueListenableBuilder:
                    Expanded( // Use Expanded to take available vertical space
                      child: LayoutBuilder( // Use LayoutBuilder to get constraints for sizing
                        builder: (context, constraints) {
                          return ValueListenableBuilder(
                            valueListenable: _taskDataListenable,
                            builder: (context, data, _) {
                              // --- Clock Page Display ---
                              if (!_isTimerPage) {
                                String displayText = data?.toString() ?? DateTimeToString.shortConvert(DateTime.now());
                                return GestureDetector(
                                  onTap: () => _speaker.currentTime(),
                                  child: Center( // Center the clock display
                                    child: Text(
                                      displayText,
                                      style: CustomTheme.clockTextTheme.copyWith(
                                        fontSize: constraints.maxWidth * 0.2, // Adjust font size dynamically
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }

                              // --- Timer Page Display ---
                              Duration currentDuration = Duration.zero;
                              if (data != null) {
                                // Data from task is String, convert it
                                currentDuration = StringToDuration.convert(data.toString());
                              } else if (_startingTime != null) {
                                // Before task sends first tick, show starting time
                                currentDuration = _startingTime!;
                              }

                              final initialDuration = _startingTime ?? Duration.zero;

                              // Calculate progress (0.0 to 1.0), ring decreases
                              final double progressFraction = (initialDuration.inMilliseconds > 0)
                                  ? (currentDuration.inMilliseconds / initialDuration.inMilliseconds).clamp(0.0, 1.0)
                                  : 0.0;

                              // Painter expects progress from 0 (full) to 1 (empty) for drawing arc
                              final double painterProgress = progressFraction;

                              // Determine if the timer has completed its cycle
                              final bool isCompleted = currentDuration <= Duration.zero && initialDuration > Duration.zero;

                              // Define colors and stroke width for the painter
                              const double strokeWidth = 18.0; // Adjust thickness as needed
                              final Color progressColor = const Color(0xFF68C7D8); // Cyan/Teal color from image
                              final Color backgroundColor = Colors.grey.shade300; // Background track color
                              final Color completedColor = Colors.redAccent; // Red color for completion

                              // Format time display consistently as HH:MM or MM:SS based on initial duration
                              String timeString;
                              if (initialDuration.inHours > 0) {
                                  // Always show HH:MM if timer started >= 1 hour
                                  timeString = DurationToString.shortConvert(currentDuration);
                              } else {
                                  // Show MM:SS if timer started < 1 hour
                                  String mm = DurationToString.twoDigits(currentDuration.inMinutes.remainder(60).abs());
                                  String ss = DurationToString.twoDigits(currentDuration.inSeconds.remainder(60).abs());
                                  timeString = "$mm:$ss";
                              }

                              // Ensure completed state shows 00:00 or 00:00:00 correctly
                              if (isCompleted) {
                                 timeString = initialDuration.inHours > 0 ? "00:00" : "00:00"; // Or adjust if you need seconds display on completion
                              }

                              final timeTextStyle = CustomTheme.clockTextTheme.copyWith(
                                 fontSize: constraints.maxWidth * 0.2, // Adjust font size dynamically
                              );


                              return GestureDetector(
                                onTap: _enterTimePickingMode, // Allow tapping to change time
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // The progress ring painter
                                      SizedBox(
                                        width: constraints.maxWidth * 0.8, // Adjust size relative to container
                                        height: constraints.maxWidth * 0.8,
                                        child: CustomPaint(
                                          painter: TimerProgressPainter(
                                            progress: painterProgress, // Pass the calculated progress
                                            progressColor: progressColor,
                                            backgroundColor: backgroundColor,
                                            completedColor: completedColor,
                                            strokeWidth: strokeWidth,
                                            isCompleted: isCompleted,
                                          ),
                                        ),
                                      ),
                                      // The time text (single Text widget)
                                      Text(
                                        timeString,
                                        style: timeTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      // Mute icon below the text
                                      Positioned(
                                        bottom: constraints.maxWidth * 0.15, // Adjust position relative to circle size
                                        child: _buildMuteIcon(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ), // End of Expanded
                    const VolumeSwitcher(),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: FooterWidget(text: _isTimerPage ? 'ZEGAR' : 'MINUTNIK', actionOnText: _switchPage),
    );
  }
}

class TimerPage extends StatefulWidget {
  final bool isTimerPage;
  const TimerPage({super.key, required this.isTimerPage});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
