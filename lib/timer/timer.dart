import 'dart:async';

import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/foreground_task/timer_task.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/timer/timer_display_row.dart';
import 'package:atloud/timer/timer_picker_widget.dart';
import 'package:atloud/timer/timer_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../components/app_bar.dart';
import '../converters/string_to_duration.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: _isTimerPage ? 'MINUTNIK' : 'ZEGAR'),
      body: Center(
        child: _isPickingTime
            ? TimePickerWidget(
                initialTime: _startingTime ?? const Duration(),
                onTimeSelected: (newTime) {
                  _startingTime = newTime;
                  UserDataStorage.storeStartingTimerValue(_startingTime!);
                  _loadUserPreferences().then((preferences) => _initPage(preferences));
                  setState(() {
                    _isPickingTime = false;
                  });
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 60.0),
                    child: ValueListenableBuilder(
                      valueListenable: _taskDataListenable,
                      builder: (context, data, _) {
                        String displayText;
                        Duration? currentDuration;
                        bool isTimerFinished = false;

                        if (_isTimerPage) {
                          if (data != null) {
                            displayText = data.toString();
                            currentDuration = StringToDuration.convert(data.toString());
                            if (currentDuration.isNegative || currentDuration.inSeconds == 0) {
                              isTimerFinished = true;
                            }
                          } else {
                            // Initial state, not started yet
                            displayText = _startingTime != null ? DurationToString.shortConvert(_startingTime!) : "--:--";
                            currentDuration = _startingTime;
                          }
                        } else {
                          displayText = data?.toString() ?? DateTimeToString.shortConvert(DateTime.now());
                        }

                        return GestureDetector(
                          onTap: _isTimerPage ? _enterTimePickingMode : () => _speaker.currentTime(),
                          child: _isTimerPage
                              ? TimerRing(
                                  duration: currentDuration,
                                  isFinished: isTimerFinished,
                                  startingTime: _startingTime,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TimeDisplayRow(displayText: displayText),
                                    ],
                                  ),
                                )
                              : TimeDisplayRow(displayText: displayText),
                        );
                      },
                    ),
                  ),
                  const VolumeSwitcher(),
                ],
              ),
      ),
      bottomNavigationBar: FooterWidget(currentPage: _isTimerPage ? AvailablePage.timer : AvailablePage.clock, actionOnClick: _switchPage,),
    );
  }
}

class TimerPage extends StatefulWidget {
  final bool isTimerPage;
  const TimerPage({super.key, required this.isTimerPage});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
