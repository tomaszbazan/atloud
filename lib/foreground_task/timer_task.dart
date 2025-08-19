import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/sound/speaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../converters/duration_to_string.dart';
import '../l10n/supported_language.dart';
import '../shared/user_data_storage.dart';

enum TaskType { timer, clock }

class TimerTaskHandler extends TaskHandler {
  static const String setTimerCommand = 'setTimerCommand';
  static const String setClockCommand = 'setClockCommand';

  static const String commandParameter = 'command';
  static const String startingTimeParameter = 'startingTime';
  static const String periodParameter = 'period';
  static const String continueAfterAlarmParameter = 'continueAfterAlarm';

  static const String stopButtonId = 'stop';

  var _taskType = TaskType.clock;

  Duration? _initialTime;
  int? _period;
  bool? _continueAfterAlarm;

  var _secondsFromTimerStart = 0;

  Future<void> _incrementTime(DateTime timestamp) async {
    _speakTimeForFirstTime();
    _secondsFromTimerStart++;
    var returnedValue = _passInformationToSpeaker(timestamp);
    _updateNotification(returnedValue);
    FlutterForegroundTask.sendDataToMain(returnedValue);
  }

  void _speakTimeForFirstTime() {
    if (_secondsFromTimerStart == 0) {
      var speaker = Speaker();
      if (_taskType == TaskType.clock) {
        speaker.currentTimeWithoutContext();
      } else {
        speaker.speakDuration(_initialTime!);
      }
    }
  }

  void _updateNotification(String returnToApp) async {
    var languageCode = await UserDataStorage.languageValue();
    var language = SupportedLanguage.fromCode(languageCode);
    FlutterForegroundTask.updateService(
      notificationTitle:
          'At Loud! ${_taskType == TaskType.clock ? _hourText(language) : _leftText(language)} $returnToApp',
      notificationIcon: const NotificationIcon(
        metaDataName: 'pl.btsoftware.atloud.default_notification_icon',
        backgroundColor: Colors.black,
      ),
      notificationInitialRoute:
          _taskType == TaskType.clock ? '/clock' : '/timer',
      notificationButtons: [
        NotificationButton(id: stopButtonId, text: _stopButtonText(language)),
      ],
    );
  }

  static String _hourText(language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Godzina: ';
      case SupportedLanguage.english:
        return 'Hour: ';
      default:
        return 'Hour: ';
    }
  }

  static String _leftText(language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Pozostało:';
      case SupportedLanguage.english:
        return 'Left:';
      default:
        return 'Left:';
    }
  }

  static String _stopButtonText(language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Zatrzymaj';
      case SupportedLanguage.english:
        return 'Stop';
      default:
        return 'Stop';
    }
  }

  String _passInformationToSpeaker(DateTime timestamp) {
    var speaker = Speaker();
    if (_taskType == TaskType.clock) {
      if (timestamp.second == 0 &&
          (_secondsFromTimerStart ~/ 60) % _period! == 0) {
        speaker.currentTimeWithoutContext();
      }
      return DateTimeToString.shortConvert(DateTime.now());
    } else {
      var secondsToTimerEnd = _initialTime!.inSeconds - _secondsFromTimerStart;

      if (secondsToTimerEnd == 0) {
        speaker.playAlarmSoundAndVibrate();
        return DurationToString.convert(const Duration(seconds: 0));
      } else {
        if (secondsToTimerEnd < 0 && !_continueAfterAlarm!) {
          return DurationToString.convert(const Duration(seconds: 0));
        }
        var initialTimeSeconds = _initialTime!.inSeconds;
        var timeLeftToEnd = Duration(
          seconds: (initialTimeSeconds - _secondsFromTimerStart),
        );
        var informationNeeded =
            (_initialTime!.inMinutes - timeLeftToEnd.inMinutes.abs()) %
                _period! ==
            0;
        if (_secondsFromTimerStart > 5 &&
            secondsToTimerEnd % 60 == 0 &&
            ((_continueAfterAlarm! && secondsToTimerEnd < 0) ||
                informationNeeded)) {
          speaker.speakDuration(timeLeftToEnd);
        }
        return DurationToString.convert(timeLeftToEnd);
      }
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

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
        _secondsFromTimerStart = 0;
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
      if (_initialTime != startingTimeDuration) {
        _secondsFromTimerStart = 0;
        _initialTime = startingTimeDuration;
      }
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == stopButtonId) {
      FlutterForegroundTask.stopService();
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
