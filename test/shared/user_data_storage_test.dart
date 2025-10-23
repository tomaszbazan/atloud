import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_helpers/mock_platform_channels.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserDataStorage', () {
    late Map<String, String> secureStorage;

    setUp(() {
      UserDataStorage.resetForTesting();
      SharedPreferences.setMockInitialValues({});
      secureStorage = setupMockPlatformChannels();
    });

    tearDown(() {
      tearDownMockPlatformChannels();
    });

    group('Current Timer Value', () {
      test('should store and retrieve current timer value', () async {
        const testDuration = Duration(minutes: 15, seconds: 30);

        UserDataStorage.storeCurrentTimerValue(testDuration);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.currentTimerValue();

        expect(result, equals(testDuration));
      });

      test('should return default value when no timer value is stored', () async {
        final result = await UserDataStorage.currentTimerValue();

        expect(result, equals(const Duration(minutes: 0, seconds: 0)));
      });
    });

    group('Starting Timer Value', () {
      test('should store and retrieve starting timer value', () async {
        const testDuration = Duration(minutes: 20);

        UserDataStorage.storeStartingTimerValue(testDuration);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.startingTimerValue();

        expect(result, equals(testDuration));
      });

      test('should return default value when no starting timer value is stored', () async {
        final result = await UserDataStorage.startingTimerValue();

        expect(result, equals(const Duration(minutes: 10)));
      });
    });

    group('Period Value', () {
      test('should store and retrieve period value', () async {
        const testValue = 5;

        UserDataStorage.storePeriodValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.periodValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no period value is stored', () async {
        final result = await UserDataStorage.periodValue();

        expect(result, equals(1));
      });
    });

    group('Volume Value', () {
      test('should store and retrieve volume value', () async {
        const testValue = 75;

        UserDataStorage.storeVolumeValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.volumeValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no volume value is stored', () async {
        final result = await UserDataStorage.volumeValue();

        expect(result, equals(50));
      });

      test('should not store volume value if it has not changed', () async {
        const testValue = 50;

        SharedPreferences.setMockInitialValues({'volumeValue': '50'});

        UserDataStorage.storeVolumeValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.volumeValue();

        expect(result, equals(testValue));
      });
    });

    group('Screen Lock Value', () {
      test('should store and retrieve screen lock value true', () async {
        const testValue = true;

        UserDataStorage.storeScreenLockValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.screenLockValue();

        expect(result, equals(testValue));
      });

      test('should store and retrieve screen lock value false', () async {
        const testValue = false;

        UserDataStorage.storeScreenLockValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.screenLockValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no screen lock value is stored', () async {
        final result = await UserDataStorage.screenLockValue();

        expect(result, equals(true));
      });
    });

    group('Alarm Type Value', () {
      test('should store and retrieve alarm type value', () async {
        const testValue = 'fanfare';

        UserDataStorage.storeAlarmTypeValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.alarmTypeValue();

        expect(result, equals(AlarmType.fanfare));
      });

      test('should return default value when no alarm type is stored', () async {
        final result = await UserDataStorage.alarmTypeValue();

        expect(result, equals(AlarmType.brass));
      });
    });

    group('Language Value', () {
      test('should store and retrieve language value', () async {
        const testValue = 'en';

        UserDataStorage.storeLanguageValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.languageValue();

        expect(result, equals(SupportedLanguage.english));
      });

      test('should use system locale when no language value is stored', () async {
        final result = await UserDataStorage.languageValue();

        expect(result, isA<SupportedLanguage>());
      });
    });

    group('Vibration Value', () {
      test('should store and retrieve vibration value true', () async {
        const testValue = true;

        UserDataStorage.storeVibrationValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.vibrationValue();

        expect(result, equals(testValue));
      });

      test('should store and retrieve vibration value false', () async {
        const testValue = false;

        UserDataStorage.storeVibrationValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.vibrationValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no vibration value is stored', () async {
        final result = await UserDataStorage.vibrationValue();

        expect(result, equals(true));
      });
    });

    group('Continue After Alarm Value', () {
      test('should store and retrieve continue after alarm value true', () async {
        const testValue = true;

        UserDataStorage.storeContinueAfterAlarmValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.continueAfterAlarmValue();

        expect(result, equals(testValue));
      });

      test('should store and retrieve continue after alarm value false', () async {
        const testValue = false;

        UserDataStorage.storeContinueAfterAlarmValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.continueAfterAlarmValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no continue after alarm value is stored', () async {
        final result = await UserDataStorage.continueAfterAlarmValue();

        expect(result, equals(true));
      });
    });

    group('Last Visited Page Value', () {
      test('should store and retrieve last visited page value', () async {
        const testValue = AvailablePage.timer;

        UserDataStorage.storeLastVisitedPageValue(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.lastVisitedPageValue();

        expect(result, equals(testValue));
      });

      test('should return default value when no last visited page value is stored', () async {
        final result = await UserDataStorage.lastVisitedPageValue();

        expect(result, equals(AvailablePage.clock));
      });
    });

    group('Is Dark Theme', () {
      test('should store and retrieve dark theme value true', () async {
        const testValue = true;

        UserDataStorage.storeIsDarkTheme(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.isDarkTheme();

        expect(result, equals(testValue));
      });

      test('should store and retrieve dark theme value false', () async {
        const testValue = false;

        UserDataStorage.storeIsDarkTheme(testValue);
        await Future.delayed(Duration.zero);

        final result = await UserDataStorage.isDarkTheme();

        expect(result, equals(testValue));
      });

      test('should return default value when no dark theme value is stored', () async {
        final result = await UserDataStorage.isDarkTheme();

        expect(result, equals(false));
      });
    });

    group('Settings Data', () {
      test('should return settings data with all values', () async {
        UserDataStorage.storeVolumeValue(80);
        UserDataStorage.storePeriodValue(3);
        UserDataStorage.storeScreenLockValue(false);
        UserDataStorage.storeAlarmTypeValue('fanfare');
        UserDataStorage.storeLanguageValue('en');
        UserDataStorage.storeVibrationValue(false);
        UserDataStorage.storeContinueAfterAlarmValue(false);
        await Future.delayed(Duration.zero);

        final settings = await UserDataStorage.settings();

        expect(settings.volumeValue, equals(80));
        expect(settings.periodValue, equals(3));
        expect(settings.screenLockValue, equals(false));
        expect(settings.alarmTypeValue, equals(AlarmType.fanfare));
        expect(settings.languageValue, equals(SupportedLanguage.english));
        expect(settings.vibrationValue, equals(false));
        expect(settings.continuationAfterAlarmValue, equals(false));
      });
    });

    group('Timer Data', () {
      test('should return timer data with all values', () async {
        UserDataStorage.storePeriodValue(2);
        UserDataStorage.storeScreenLockValue(true);
        UserDataStorage.storeStartingTimerValue(const Duration(minutes: 15));
        UserDataStorage.storeContinueAfterAlarmValue(true);
        await Future.delayed(Duration.zero);

        final timerData = await UserDataStorage.timerData();

        expect(timerData.periodValue, equals(2));
        expect(timerData.screenLockValue, equals(true));
        expect(timerData.startingTimerValue, equals(const Duration(minutes: 15)));
        expect(timerData.continuationAfterAlarmValue, equals(true));
      });
    });

    group('Data Migration', () {
      test('should migrate data from secure storage to shared preferences', () async {
        secureStorage['currentTimerValue'] = '05:30';
        secureStorage['startingTimerValue'] = '15:00';
        secureStorage['periodValue'] = '3';
        secureStorage['volumeValue'] = '75';
        secureStorage['screenLockValue'] = 'false';
        secureStorage['alarmTypeValue'] = 'fanfare';
        secureStorage['languageValueV2'] = 'en';
        secureStorage['vibrationValue'] = 'false';
        secureStorage['continueAfterAlarmValue'] = 'false';
        secureStorage['lastVisitedPageValue'] = 'timer';
        secureStorage['isDarkTheme'] = 'true';

        final currentTimer = await UserDataStorage.currentTimerValue();
        final startingTimer = await UserDataStorage.startingTimerValue();
        final period = await UserDataStorage.periodValue();
        final volume = await UserDataStorage.volumeValue();
        final screenLock = await UserDataStorage.screenLockValue();
        final alarmType = await UserDataStorage.alarmTypeValue();
        final language = await UserDataStorage.languageValue();
        final vibration = await UserDataStorage.vibrationValue();
        final continueAfterAlarm = await UserDataStorage.continueAfterAlarmValue();
        final lastPage = await UserDataStorage.lastVisitedPageValue();
        final darkTheme = await UserDataStorage.isDarkTheme();

        expect(currentTimer, equals(const Duration(minutes: 5, seconds: 30)));
        expect(startingTimer, equals(const Duration(minutes: 15)));
        expect(period, equals(3));
        expect(volume, equals(75));
        expect(screenLock, equals(false));
        expect(alarmType, equals(AlarmType.fanfare));
        expect(language, equals(SupportedLanguage.english));
        expect(vibration, equals(false));
        expect(continueAfterAlarm, equals(false));
        expect(lastPage, equals(AvailablePage.timer));
        expect(darkTheme, equals(true));
      });

      test('should not migrate again after first migration', () async {
        secureStorage['currentTimerValue'] = '05:30';

        await UserDataStorage.currentTimerValue();

        secureStorage['currentTimerValue'] = '10:00';

        final result = await UserDataStorage.currentTimerValue();

        expect(result, equals(const Duration(minutes: 5, seconds: 30)));
      });
    });
  });
}
