import 'package:atloud/timer/timer_alarm_calculator.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerAlarmCalculator', () {
    group('Clock mode', () {
      test('should announce current time at start', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 10);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(0);

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isTrue);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should announce in first minute when current time seconds is 0', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 00);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(40); // 40 seconds

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isTrue);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should not announce in first minute when current time seconds is not 0', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 53);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(40); // 40 seconds

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 7));
      });

      test('should correctly calculate nextAnnouncement inside first period', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 10);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(125); // 2 minutes and 5 seconds

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 230)); // 3 minutes and 50 seconds to next = 230 seconds
      });

      test('should announce after first period', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 00);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(355); // 5 minutes and 55 seconds

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isTrue);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should correctly calculate nextAnnouncement inside second period', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 10);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(445); // 7 minutes and 25 seconds

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 170)); // 2 minutes and 50 seconds to next = 170 seconds
      });

      test('should announce after second period', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 05, 00);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(655); // 10 minutes and 55 seconds

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isTrue);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, isNull);
        expect(decision.displayTime, "12:05");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });
    });

    group('Timer mode', () {
      test('should announce initial duration at start', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 10),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(0);

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isTrue);
        expect(decision.timeLeft, equals(const Duration(minutes: 10)));
        expect(decision.displayTime, "00:10:00");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should play alarm when timer reaches zero', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 5),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(300); // 5 minutes elapsed

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isTrue);
        expect(decision.timeLeft, equals(const Duration(minutes: 0)));
        expect(decision.displayTime, "00:00:00");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should announce duration at period intervals', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 10),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(120); // 2 minutes elapsed

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isTrue);
        expect(decision.timeLeft, equals(const Duration(minutes: 8)));
        expect(decision.displayTime, "00:08:00");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should not announce when not at first period interval', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 10),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(90); // 1.5 minutes elapsed

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, equals(const Duration(minutes: 8, seconds: 30)));
        expect(decision.displayTime, "00:08:30");
        expect(decision.nextAnnouncement, Duration(seconds: 30)); // 30 seconds to next announcement
      });

      test('should not announce when not at second period interval', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 10),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(220); // 3 minutes and 40 seconds elapsed

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, equals(const Duration(minutes: 6, seconds: 20)));
        expect(decision.displayTime, "00:06:20");
        expect(decision.nextAnnouncement, Duration(seconds: 20)); // 20 seconds to next announcement
      });

      test('should not announce during first 5 seconds', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 10),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(3);

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, equals(const Duration(minutes: 8, seconds: 57)));
        expect(decision.displayTime, "00:08:57");
        expect(decision.nextAnnouncement, Duration(seconds: 57)); // 57 seconds to next announcement
      });

      test('should continue announcing after alarm when continueAfterAlarm is true', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 5),
          period: 2,
          continueAfterAlarm: true,
        );

        final decision = calculator.alarmNeeded(420); // 7 minutes elapsed (2 minutes over)

        expect(decision.shouldAnnounce, isTrue);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isTrue);
        expect(decision.timeLeft, equals(const Duration(minutes: -2)));
        expect(decision.displayTime, "-00:02:00");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });

      test('should not announce after alarm when continueAfterAlarm is false', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.timer,
          initialTime: const Duration(minutes: 5),
          period: 2,
          continueAfterAlarm: false,
        );

        final decision = calculator.alarmNeeded(420); // 7 minutes elapsed

        expect(decision.shouldAnnounce, isFalse);
        expect(decision.shouldAnnounceCurrentTime, isFalse);
        expect(decision.shouldAnnounceTimeLeft, isFalse);
        expect(decision.timeLeft, equals(const Duration(seconds: 0)));
        expect(decision.displayTime, "00:00:00");
        expect(decision.nextAnnouncement, Duration(seconds: 0));
      });
    });

    group('Clock mode with mocked time', () {
      test('should display correct time at midnight', () {
        final fixedTime = DateTime(2023, 1, 1, 0, 0, 0);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 1,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(0);
        final displayTime = decision.displayTime;

        expect(displayTime, equals('00:00'));
      });

      test('should display correct time at noon', () {
        final fixedTime = DateTime(2023, 1, 1, 12, 0, 0);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 1,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(0);
        final displayTime = decision.displayTime;

        expect(displayTime, equals('12:00'));
      });

      test('should display correct time in evening', () {
        final fixedTime = DateTime(2023, 1, 1, 18, 30, 45);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 1,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(1000); // seconds from start don't matter for clock
        final displayTime = decision.displayTime;

        expect(displayTime, equals('18:30'));
      });

      test('should calculate display time correctly', () {
        final fixedTime = DateTime(2023, 1, 1, 6, 55, 0);
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 2,
          continueAfterAlarm: false,
          clock: Clock.fixed(fixedTime),
        );

        final decision = calculator.alarmNeeded(185); // 3 minutes elapsed and 5 seconds
        final displayTime = decision.displayTime;

        expect(displayTime, equals('06:55')); // Fixed time, independent of elapsed seconds
      });
    });

    group('Edge cases', () {
      test('should work with default clock when not specified', () {
        final calculator = TimerAlarmCalculator(
          taskType: TaskType.clock,
          period: 5,
          continueAfterAlarm: false,
          // clock not specified, should use default
        );

        // This should not throw and should return a string
        final decision = calculator.alarmNeeded(0);
        final displayTime = decision.displayTime;

        expect(displayTime, isNotEmpty);
        expect(displayTime, matches(r'^\d{2}:\d{2}$')); // HH:MM format
      });
    });
  });
}