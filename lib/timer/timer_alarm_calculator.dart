import 'package:clock/clock.dart';

import '../converters/duration_to_string.dart';
import '../converters/date_time_to_string.dart';

enum TaskType { timer, clock }

class TimerAlarmCalculator {
  final TaskType taskType;
  final Duration? initialTime;
  final int period;
  final bool continueAfterAlarm;
  final Clock clock;

  const TimerAlarmCalculator({
    required this.taskType,
    this.initialTime,
    required this.period,
    required this.continueAfterAlarm,
    this.clock = const Clock(),
  });

  AlarmDecision alarmNeeded(int secondsFromStart) {
    final displayTime = taskType == TaskType.clock
        ? _getClockDisplayTime()
        : _getTimerDisplayTime(secondsFromStart);
    
    final nextAnnouncement = taskType == TaskType.clock
        ? _calculateTimeToNextAnnouncementForClock(secondsFromStart)
        : _calculateTimeToNextAnnouncementForTimer(secondsFromStart);

    if (taskType == TaskType.clock) {
      return _shouldAnnounceForClock(secondsFromStart, displayTime, nextAnnouncement);
    } else {
      return _shouldAnnounceForTimer(secondsFromStart, displayTime, nextAnnouncement);
    }
  }

  AlarmDecision _shouldAnnounceForClock(int secondsFromStart, String displayTime, Duration nextAnnouncement) {
    if (_isTimerAtZero(secondsFromStart) || nextAnnouncement.inSeconds == 0) {
      return AlarmDecision.announceCurrentTime(displayTime, nextAnnouncement);
    }

    return AlarmDecision.noAnnouncement(displayTime, nextAnnouncement);
  }

  AlarmDecision _shouldAnnounceForTimer(int secondsFromStart, String displayTime, Duration nextAnnouncement) {
    if (_isTimerAtZero(secondsFromStart)) {
      return AlarmDecision.announceDuration(initialTime!, displayTime, Duration.zero);
    }

    final secondsToTimerEnd = initialTime!.inSeconds - secondsFromStart;
    final timeLeftToEnd = Duration(
      seconds: secondsToTimerEnd,
    );

    // Check if timer exactly ends (alarm time)
    if (_isTimerAtZero(secondsToTimerEnd)) {
      return AlarmDecision.playAlarm(displayTime, nextAnnouncement);
    }

    // Check if timer has ended and we shouldn't continue
    if (secondsToTimerEnd < 0 && !continueAfterAlarm) {
      return AlarmDecision.noAnnounceTimer(Duration.zero, displayTime, nextAnnouncement);
    }

    final informationNeeded =
        (initialTime!.inMinutes - timeLeftToEnd.inMinutes.abs()) % period == 0;

    if (secondsFromStart > 5 &&
        secondsToTimerEnd % 60 == 0 &&
        ((continueAfterAlarm && secondsToTimerEnd < 0) || informationNeeded)) {
      return AlarmDecision.announceDuration(timeLeftToEnd, displayTime, Duration.zero);
    }

    return AlarmDecision.noAnnounceTimer(timeLeftToEnd, displayTime, nextAnnouncement);
  }

  Duration _calculateTimeToNextAnnouncementForClock(int secondsFromStart) {
    if (_isTimerAtZero(secondsFromStart)) {
      return const Duration(seconds: 0);
    }
    if (_isInFirstMinute(secondsFromStart)) {
      return Duration(seconds: (60 - clock.now().second) % 60);
    }

    final startTime = clock.now().subtract(Duration(seconds: secondsFromStart));
    final secondsTakenByFirstMinute = (60 - startTime.second) % 60;
    final secondsFromFullMinute = secondsFromStart - secondsTakenByFirstMinute;
    final secondsAfterLastPeriod = secondsFromFullMinute % _periodInSeconds();

    return Duration(seconds: (_periodInSeconds() - secondsAfterLastPeriod) % _periodInSeconds());
  }

  int _periodInSeconds() => (period * 60);

  bool _isTimerAtZero(int secondsFromStart) => secondsFromStart == 0;

  bool _isInFirstMinute(int secondsFromStart) => (clock.now().second - secondsFromStart) >= 0;

  Duration _calculateTimeToNextAnnouncementForTimer(int secondsFromStart) {
    final secondsToTimerEnd = initialTime!.inSeconds - secondsFromStart;

    // If timer has ended and we don't continue after alarm, no more announcements
    if (secondsToTimerEnd < 0 && !continueAfterAlarm) {
      return const Duration(seconds: 0);
    }

    // If timer is about to end (at 0), that's when the alarm plays
    if (_isTimerAtZero(secondsToTimerEnd)) {
      return const Duration(seconds: 0);
    }

    // Calculate minutes passed based on how long the timer has been running
    final minutesPassed = secondsFromStart ~/ 60;

    // Find the next minute mark that matches the period
    int nextAnnouncementMinute = minutesPassed;
    do {
      nextAnnouncementMinute++;
    } while (nextAnnouncementMinute % period != 0);

    // Calculate seconds until the next announcement
    final secondsUntilNextMinute = 60 - (secondsFromStart % 60);
    final minutesToWait = nextAnnouncementMinute - minutesPassed - 1;
    final totalSecondsToNext = minutesToWait * 60 + secondsUntilNextMinute;

    // Special case: if we're very close to the timer end, that takes priority
    if (secondsToTimerEnd > 0 && secondsToTimerEnd < totalSecondsToNext) {
      return Duration(seconds: secondsToTimerEnd);
    }

    return Duration(seconds: totalSecondsToNext);
  }

  String _getClockDisplayTime() {
    return DateTimeToString.shortConvert(clock.now());
  }

  String _getTimerDisplayTime(int secondsFromStart) {
    final secondsToTimerEnd = initialTime!.inSeconds - secondsFromStart;

    if (_isTimerAtZero(secondsToTimerEnd) || (secondsToTimerEnd < 0 && !continueAfterAlarm)) {
      return DurationToString.convert(const Duration(seconds: 0));
    }

    final timeLeftToEnd = Duration(
      seconds: secondsToTimerEnd,
    );
    return DurationToString.convert(timeLeftToEnd);
  }
}

class AlarmDecision {
  final AnnouncementType type;
  final Duration? timeLeft;
  final String displayTime;
  final Duration nextAnnouncement;

  const AlarmDecision._(this.type, this.timeLeft, this.displayTime, this.nextAnnouncement);

  static AlarmDecision noAnnouncement(String displayTime, Duration nextAnnouncement) =>
      AlarmDecision._(AnnouncementType.none, null, displayTime, nextAnnouncement);

  static AlarmDecision noAnnounceTimer(Duration timeLeft, String displayTime, Duration nextAnnouncement) =>
      AlarmDecision._(AnnouncementType.none, timeLeft, displayTime, nextAnnouncement);

  static AlarmDecision announceCurrentTime(String displayTime, Duration nextAnnouncement) =>
      AlarmDecision._(AnnouncementType.currentTime, null, displayTime, nextAnnouncement);

  static AlarmDecision announceDuration(Duration duration, String displayTime, Duration nextAnnouncement) =>
      AlarmDecision._(AnnouncementType.duration, duration, displayTime, nextAnnouncement);

  static AlarmDecision playAlarm(String displayTime, Duration nextAnnouncement) =>
      AlarmDecision._(AnnouncementType.alarm, null, displayTime, nextAnnouncement);

  bool get shouldAnnounce => type != AnnouncementType.none;
  bool get shouldAnnounceCurrentTime => type == AnnouncementType.currentTime;
  bool get shouldAnnounceTimeLeft => type == AnnouncementType.duration;
  bool get shouldPlayAlarm => type == AnnouncementType.alarm;
}

enum AnnouncementType {
  none,
  currentTime,
  duration,
  alarm,
}