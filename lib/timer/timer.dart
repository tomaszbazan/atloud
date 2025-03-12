import 'dart:async';

import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/duration_to_voice.dart';
import 'package:atloud/converters/time_of_day_to_duration.dart';
import 'package:atloud/foreground_task/clock_task.dart';
import 'package:atloud/foreground_task/foreground_task_starter.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/timer/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../sound/speaker.dart';
import '../theme/colors.dart';

class _TimerPageState extends State<TimerPage> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  var _isTimerPage = true;

  final _speaker = Speaker();

  var _currentTime;
  var _startingTime;

  var _startTime = DateTime.now();

  var _continueAfterTimer = false;
  var _period = 1;
  var _vibrationOn = true;

  @override
  void initState() {
    _isTimerPage = widget.isTimerPage;
    _loadUserPreferences().whenComplete(() => _initPage());
    // _initPage();

    super.initState();
  }

  void _initPage() {
    _startTime = DateTime.now();
    if(_isTimerPage) {
      _speaker.speak(DurationToVoice.covert(_startingTime));
    } else {
      _speaker.currentTime();
    }

    _startTimer();
  }

  void _timerTick(Object data) {
    _taskDataListenable.value = data;
    print('tick $data');

    var secondsFromTaskStart = data as int;

    if (_isTimerPage) {
      _timerSound(secondsFromTaskStart);
    } else {
      // _clockSound(secondsFromTaskStart);
    }
  }

  // void _clockSound(int secondsFromTaskStart) {
  //   var secondsToFullMinute = secondsFromTaskStart - (60 - _startTime.second);
  //
  //   if (secondsToFullMinute % 60 == 0 && ((secondsToFullMinute) ~/ 60) % _period == 0) {
  //     _speaker.currentTime();
  //     if (_vibrationOn) {
  //       Vibration.vibrate(duration: 1000, repeat: 3);
  //     }
  //   }
  // }

  void _timerSound(int secondsFromTaskStart) {
    if (_startingTime == null) {
      return;
    }
    var secondsTimeTimerEnd = _startingTime.inSeconds - secondsFromTaskStart;

    if (secondsTimeTimerEnd == 0) {
      _speaker.playSound();
      if (_vibrationOn) {
        Vibration.vibrate(duration: 1000, repeat: 3);
      }
    } else {
      var informationNeeded = (_startingTime.inMinutes - _currentTime.inMinutes.abs()) % _period == 0;
      if (secondsTimeTimerEnd % 60 == 0 && ((_continueAfterTimer && secondsTimeTimerEnd < 0) || informationNeeded)) {
        _speaker.speak(DurationToVoice.covert(_currentTime));
      }
    }
  }

  Future<void> _loadUserPreferences() async {
    var screenLockValue = await UserDataStorage.screenLockValue();
    WakelockPlus.toggle(enable: screenLockValue);

    _continueAfterTimer = await UserDataStorage.continueAfterTimeValue();
    _vibrationOn = await UserDataStorage.vibrationValue();
    _startingTime = await UserDataStorage.startingTimerValue();
    _period = await UserDataStorage.periodValue();
  }

  void _showTimePicker() async {
    final TimeOfDay? time = await TimePicker.showPicker(context, _startingTime);
    setState(() {
      if (time != null) {
        _startingTime = TimeOfDayToDuration.convert(time);
        UserDataStorage.storeStartingTimerValue(_startingTime);
        setState(() {
          _currentTime = _startingTime;
        });
        _initPage();
      }
    });
  }

  void _switchPage() {
    setState(() {
      _isTimerPage = !_isTimerPage;
    });
    FlutterForegroundTask.sendDataToTask(ClockTaskHandler.setClockCommand);
    if (_isTimerPage) {
      FlutterForegroundTask.sendDataToTask(ClockTaskHandler.setTimerCommand);
      UserDataStorage.storeLastVisitedPageValue(AvailablePage.timer);
    } else {
      FlutterForegroundTask.sendDataToTask(ClockTaskHandler.setClockCommand);
      UserDataStorage.storeLastVisitedPageValue(AvailablePage.clock);
    }
    _initPage();
  }

  void _clean() {
    // ForegroundTaskStarter.stopService(); // TODO: To nie powinno tutaj być LUB nie powinieniem przekazywać tego do timera
    // FlutterForegroundTask.removeTaskDataCallback(_timerTick);
    // _taskDataListenable.dispose();
    // setState(() {
    //   _currentTime = _startingTime;
    // });
  }

  void _startTimer() {
    ForegroundTaskStarter.startService(_timerTick);
  }

  @override
  void dispose() {
    _clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(text: ''),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: ValueListenableBuilder(
                    valueListenable: _taskDataListenable,
                    builder: (context, data, _) {
                      return _isTimerPage
                          ? TextButton(
                              onPressed: _showTimePicker,
                              child: Text(DurationToString.convert(_durationToPresent(data)), style: TextStyle(fontSize: 70, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value)))
                          : TextButton(
                              onPressed: () => _speaker.currentTime(),
                              child: Text(DateFormat('HH:mm').format((data == null ? _startTime : _startTime.add(Duration(seconds: data as int)))),
                                  style: TextStyle(fontSize: 120, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value)));
                    })),
            const VolumeSwitcher(),
            const Spacer(),
            FooterWidget(text: _isTimerPage ? 'ZEGAR' : 'MINUTNIK', actionOnText: _switchPage)
          ],
        ));
  }

  _durationToPresent(Object? data) {
    if (data != null) {
      var startSeconds = _startingTime.inSeconds;
      var secondsFromTaskStart = data as int;
      _currentTime = Duration(seconds: (startSeconds - secondsFromTaskStart));
      return _currentTime;
    } else {
      return _startingTime;
    }
  }
}

class TimerPage extends StatefulWidget {
  final bool isTimerPage;
  const TimerPage({super.key, required this.isTimerPage});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
