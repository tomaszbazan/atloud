import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/sound/speaker.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../converters/duration_to_string.dart';
import '../l10n/supported_language.dart';
import '../shared/user_data_storage.dart';
import '../timer/timer_alarm_calculator.dart';

class TimerTaskHandler extends TaskHandler {
  static const String setTimerCommand = 'setTimerCommand';
  static const String setClockCommand = 'setClockCommand';

  static const String returnedDisplayTime = 'displayTime';
  static const String returnedNextAnnouncement = 'nextAnnouncementIn';

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

  TimerAlarmCalculator? get _calculator {
    if (_period == null || (_taskType == TaskType.timer && _initialTime == null)) {
      return null;
    }
    return TimerAlarmCalculator(
      taskType: _taskType,
      initialTime: _initialTime,
      period: _period!,
      continueAfterAlarm: _continueAfterAlarm ?? false,
      clock: const Clock(),
    );
  }

  Future<void> _incrementTime() async {
    final calculator = _calculator;
    if (calculator == null) return;

    final decision = calculator.alarmNeeded(_secondsFromTimerStart);
    _handleAnnouncementDecision(decision);

    _secondsFromTimerStart++;

    final displayTime = decision.displayTime;
    final timeToNextAnnouncement = decision.nextAnnouncement;

    _updateNotification(displayTime);
    FlutterForegroundTask.sendDataToMain({
      returnedDisplayTime: displayTime,
      returnedNextAnnouncement: DurationToString.convert(timeToNextAnnouncement),
    });
  }

  void _handleAnnouncementDecision(AlarmDecision decision) {
    if (!decision.shouldAnnounce) return;

    final speaker = Speaker();
    if (decision.shouldAnnounceCurrentTime) {
      speaker.currentTimeWithoutContext();
    } else if (decision.shouldAnnounceTimeLeft) {
      speaker.speakDuration(decision.timeLeft!);
    } else if (decision.shouldPlayAlarm) {
      speaker.playAlarmSoundAndVibrate();
    }
  }

  void _updateNotification(String returnToApp) async {
    var language = await UserDataStorage.languageValue();
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

  static String _hourText(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Godzina: ';
      case SupportedLanguage.english:
        return 'Hour: ';
    }
  }

  static String _leftText(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Pozostało:';
      case SupportedLanguage.english:
        return 'Left:';
    }
  }

  static String _stopButtonText(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Zatrzymaj';
      case SupportedLanguage.english:
        return 'Stop';
    }
  }


  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {
    _incrementTime();
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
  }

  @override
  void onNotificationDismissed() {
    FlutterForegroundTask.stopService();
  }
}
