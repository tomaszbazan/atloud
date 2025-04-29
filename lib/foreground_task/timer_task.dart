import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/sound/speaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../converters/duration_to_string.dart';
import '../converters/duration_to_voice.dart';

enum TaskType { timer, clock }

class TimerTaskHandler extends TaskHandler {
  static const String setTimerCommand = 'setTimerCommand';
  static const String setClockCommand = 'setClockCommand';

  static const String commandParameter = 'command';
  static const String startingTimeParameter = 'startingTime';
  static const String periodParameter = 'period';
  static const String continueAfterAlarmParameter = 'continueAfterAlarm';

  static const String stopButtonId = 'stop';
  static const String muteButtonId = 'mute';

  var _taskType = TaskType.clock;

  Duration? _startingTime;
  int? _period;
  bool? _continueAfterAlarm;

  var _seconds = 0;

  Future<void> _incrementTime(DateTime timestamp) async {
    if (_seconds == 0) {
      var speaker = Speaker();
      if (_taskType == TaskType.clock) {
        speaker.currentTime();
      } else {
        speaker.speak(DurationToVoice.covert(_startingTime!));
      }
    }
    _seconds++;
    var returnedValue = _passInformationToSpeaker(timestamp);
    print('Returned value: $returnedValue');
    _updateNotification(returnedValue);
    FlutterForegroundTask.sendDataToMain(returnedValue);
  }

  void _updateNotification(String returnToApp) {
    FlutterForegroundTask.updateService(
      notificationTitle: 'At Loud! ${_taskType == TaskType.clock ? 'Godzina: ' : 'Pozostało: '} $returnToApp',
      notificationIcon: const NotificationIcon(metaDataName: 'pl.btsoftware.atloud.default_notification_icon', backgroundColor: Colors.black),
      notificationInitialRoute: _taskType == TaskType.clock ? '/clock' : '/timer',
      notificationButtons: [const NotificationButton(id: stopButtonId, text: 'Zatrzymaj'), const NotificationButton(id: muteButtonId, text: 'Wycisz')],
    );
  }

  String _passInformationToSpeaker(DateTime timestamp) {
    var speaker = Speaker();
    if (_taskType == TaskType.clock) {
      if (timestamp.second == 0 && (_seconds ~/ 60) % _period! == 0) {
        speaker.currentTime();
      }
      return DateTimeToString.shortConvert(DateTime.now());
    } else {
      var secondsTimeTimerEnd = _startingTime!.inSeconds - _seconds;

      if (secondsTimeTimerEnd == 0) {
        speaker.playSound();
        return DurationToString.convert(const Duration(seconds: 0));
      } else {
        var startSeconds = _startingTime!.inSeconds;
        var currentTime = Duration(seconds: (startSeconds - _seconds));
        var informationNeeded = (_startingTime!.inMinutes - currentTime.inMinutes.abs()) % _period! == 0;
        if (secondsTimeTimerEnd % 60 == 0 && ((_continueAfterAlarm! && secondsTimeTimerEnd < 0) || informationNeeded)) {
          speaker.speak(DurationToVoice.covert(currentTime));
        }
        return DurationToString.convert(currentTime);
      }
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    if (_taskType == TaskType.clock) {
      var speaker = Speaker();
      speaker.currentTime();
    }
    _incrementTime(timestamp);
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _incrementTime(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}

  @override
  void onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      _handleStartingTime(data);
      _handlePeriod(data);
      _handleContinueAfterAlarm(data);
      _handleCommand(data);
    }
  }

  void _handleCommand(Map<String, dynamic> data) {
    var command = data[commandParameter];
    if (command != null) {
      var oldType = _taskType;
      _taskType = command == setTimerCommand ? TaskType.timer : TaskType.clock;
      if (oldType != _taskType) {
        _seconds = 0;
      }
    }
  }

  void _handleContinueAfterAlarm(Map<String, dynamic> data) {
    var continueAfterAlarm = data[TimerTaskHandler.continueAfterAlarmParameter];
    if (continueAfterAlarm != null) {
      _continueAfterAlarm = continueAfterAlarm;
    }
  }

  void _handlePeriod(Map<String, dynamic> data) {
    var period = data[TimerTaskHandler.periodParameter];
    if (period != null) {
      _period = period;
    }
  }

  void _handleStartingTime(Map<String, dynamic> data) {
    var startingTime = data[TimerTaskHandler.startingTimeParameter];
    if (startingTime != null) {
      var startingTimeDuration = StringToDuration.convert(startingTime);
      if (_startingTime != startingTimeDuration) {
        _seconds = 0;
        _startingTime = startingTimeDuration;
      }
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == stopButtonId) {
      FlutterForegroundTask.stopService();
    }
    if (id == muteButtonId) {
      var speaker = Speaker();
      speaker.playSound();
    }
  }

  @override
  void onNotificationPressed() {
    print('onNotificationPressed');
  }

  @override
  void onNotificationDismissed() {
    FlutterForegroundTask.stopService();
  }
}
