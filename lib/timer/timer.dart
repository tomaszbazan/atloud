import 'dart:async';

import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/foreground_task/timer_task.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/timer/next_announcement_widget.dart';
import 'package:atloud/timer/timer_display_row.dart';
import 'package:atloud/timer/timer_picker_widget.dart';
import 'package:atloud/timer/timer_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../components/app_bar.dart';
import '../converters/string_to_duration.dart';
import '../l10n/app_localizations.dart';
import '../shared/available_page.dart';
import '../sound/speaker.dart';

class _TimerPageState extends State<TimerPage> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  var _isTimerPage = true;

  final _speaker = Speaker();
  Duration? _startingTime;

  bool _isPickingTime = false;
  int? _period;

  @override
  void initState() {
    _isTimerPage = widget.isTimerPage;
    _initializePageAsync();
    super.initState();
  }

  Future<void> _initializePageAsync() async {
    await ForegroundTaskStarter.startService(_timerTick);
    final preferences = await _loadUserPreferences();
    _initPage(preferences);
  }

  void _initPage(Map<String, dynamic> preferences) {
    if (_isTimerPage) {
      FlutterForegroundTask.sendDataToTask({...preferences, TimerTaskHandler.commandParameter: TimerTaskHandler.setTimerCommand});
    } else {
      FlutterForegroundTask.sendDataToTask({...preferences, TimerTaskHandler.commandParameter: TimerTaskHandler.setClockCommand});
    }
    setState(() {
      _period = preferences[TimerTaskHandler.periodParameter] as int?;
    });
  }

  void _timerTick(dynamic data) {
    _taskDataListenable.value = data;
  }

  Future<Map<String, dynamic>> _loadUserPreferences() async {
    var screenLockValue = await UserDataStorage.screenLockValue();
    WakelockPlus.toggle(enable: screenLockValue);

    _startingTime = await UserDataStorage.startingTimerValue();

    return {
      TimerTaskHandler.startingTimeParameter: DurationToString.convert(_startingTime!),
      TimerTaskHandler.periodParameter: await UserDataStorage.periodValue(),
      TimerTaskHandler.continueAfterAlarmParameter: await UserDataStorage.continueAfterAlarmValue(),
    };
  }

  Future<void> _switchPage() async {
    setState(() {
      _isPickingTime = false;
      _isTimerPage = !_isTimerPage;
    });
    final preferences = await _loadUserPreferences();
    _initPage(preferences);
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(text: _isTimerPage ? localizations.timerTab : localizations.clockTab),
      body: Stack(
        children: [
          Center(
            child:
                _isPickingTime
                    ? TimePickerWidget(
                      initialTime: _startingTime ?? const Duration(),
                      onTimeSelected: (newTime) async {
                        _startingTime = newTime;
                        UserDataStorage.storeStartingTimerValue(_startingTime!);
                        final preferences = await _loadUserPreferences();
                        _initPage(preferences);
                        setState(() {
                          _isPickingTime = false;
                        });
                      },
                    )
                    : Container(
                      margin: const EdgeInsets.symmetric(vertical: 60.0),
                      child: ValueListenableBuilder(
                        valueListenable: _taskDataListenable,
                        builder: (context, data, _) {
                          String displayText;
                          Duration? currentDuration;

                          if (_isTimerPage) {
                            if (data != null) {
                              if (data is Map<String, dynamic>) {
                                displayText = data[TimerTaskHandler.returnedDisplayTime] ?? data.toString();
                                currentDuration = StringToDuration.convert(displayText);
                              } else {
                                displayText = data.toString();
                                currentDuration = StringToDuration.convert(data.toString());
                              }
                            } else {
                              displayText = _startingTime != null ? DurationToString.convert(_startingTime!) : "--:--";
                              currentDuration = _startingTime;
                            }
                          } else {
                            if (data is Map<String, dynamic>) {
                              displayText = data[TimerTaskHandler.returnedDisplayTime] ?? DateTimeToString.shortConvert(DateTime.now());
                            } else {
                              displayText = data?.toString() ?? DateTimeToString.shortConvert(DateTime.now());
                            }
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 30.0),
                                child: GestureDetector(
                                  onTap: _isTimerPage ? _enterTimePickingMode : () => _speaker.currentTime(context),
                                  child: TimerRing(
                                    duration: currentDuration,
                                    startingTime: _startingTime,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        TimeDisplayRow(displayText: displayText),
                                        const Align(alignment: Alignment.bottomCenter, child: Padding(padding: EdgeInsets.only(bottom: 20.0), child: VolumeSwitcher())),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
          ),
          _isPickingTime ? Container() : NextAnnouncementWidget(period: _period),
        ],
      ),
      bottomNavigationBar: FooterWidget(
        currentPage: _isTimerPage ? AvailablePage.timer : AvailablePage.clock,
        onClockTap: () => _switchPage(),
        onTimerTap: () => _switchPage(),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  final bool isTimerPage;

  const TimerPage({super.key, required this.isTimerPage});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
