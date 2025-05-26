import 'dart:async';

import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/foreground_task/timer_task.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:atloud/timer/timer_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../components/app_bar.dart';
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
    print("Starting time: $_startingTime");

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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30.0),
                    child: ValueListenableBuilder(
                      valueListenable: _taskDataListenable,
                      builder: (context, data, _) {
                        String displayText;

                        if (_isTimerPage) {
                          displayText = data?.toString() ?? (_startingTime != null ? DurationToString.shortConvert(_startingTime!) : "--:--");
                        } else {
                          displayText = data?.toString() ?? DateTimeToString.shortConvert(DateTime.now());
                        }

                        return SizedBox(
                          height: 300,
                          child: GestureDetector(
                            onTap: _isTimerPage ? _enterTimePickingMode : () => _speaker.currentTime(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Text(displayText.split(":").first, style: CustomTheme.clockTextTheme, textAlign: TextAlign.right)),
                                Text(":", style: CustomTheme.clockTextTheme),
                                Expanded(child: Text(displayText.split(":").last, style: CustomTheme.clockTextTheme, textAlign: TextAlign.left))
                              ],
                            ),
                          ),
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
