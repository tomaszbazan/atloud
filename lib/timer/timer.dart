import 'dart:async';

import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/time_of_day_to_duration.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/foreground_task/timer_task.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/timer/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../sound/speaker.dart';
import '../theme/colors.dart';

class _TimerPageState extends State<TimerPage> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  var _isTimerPage = true;

  final _speaker = Speaker();

  Duration? _startingTime;

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

  void _showTimePicker() async {
    final TimeOfDay? time = await TimePicker.showPicker(context, _startingTime!);
    setState(() {
      if (time != null) {
        _startingTime = TimeOfDayToDuration.convert(time);
        UserDataStorage.storeStartingTimerValue(_startingTime!);
        _loadUserPreferences().then((preferences) => _initPage(preferences));
      }
    });
  }

  void _switchPage() {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(text: ''),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: ValueListenableBuilder(
                  valueListenable: _taskDataListenable,
                  builder: (context, data, _) {
                    var textStyle = TextStyle(fontSize: 110, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value);
                    if (data != null) {
                      return TextButton(
                        onPressed: _isTimerPage ? _showTimePicker : () => _speaker.currentTime(),
                        child: Text(data.toString(), style: textStyle),
                      );
                    } else if (_isTimerPage) {
                      return FutureBuilder(
                          future: UserDataStorage.startingTimerValue(),
                          builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                            return Text(_getOrDefault(snapshot), style: textStyle);
                          });
                    } else {
                      return TextButton(
                        onPressed: _isTimerPage ? _showTimePicker : () => _speaker.currentTime(),
                        child: Text(DateTimeToString.shortConvert(DateTime.now()), style: textStyle),
                      );
                    }
                  },
                ),
              ),
              const VolumeSwitcher(),
            ],
          ),
        ),
      bottomNavigationBar: FooterWidget(text: _isTimerPage ? 'ZEGAR' : 'MINUTNIK', actionOnText: _switchPage),
    );
  }

  String _getOrDefault(AsyncSnapshot<Duration> startingTime) => startingTime.hasData ? DurationToString.shortConvert(startingTime.requireData) : '';
}

class TimerPage extends StatefulWidget {
  final bool isTimerPage;
  const TimerPage({super.key, required this.isTimerPage});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
