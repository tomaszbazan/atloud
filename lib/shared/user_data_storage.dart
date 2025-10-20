import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:atloud/sound/speaker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../settings/settings_data.dart';
import '../timer/timer_user_preferences.dart';

class UserDataStorage {
  static const String _currentTimerValueKey = 'currentTimerValue';
  static const String _startingTimerValueKey = 'startingTimerValue';
  static const String _periodValueKey = 'periodValue';
  static const String _volumeValueKey = 'volumeValue';
  static const String _screenLockValueKey = 'screenLockValue';
  static const String _alarmTypeValueKey = 'alarmTypeValue';
  static const String _languageValueKey = 'languageValueV2';
  static const String _vibrationValueKey = 'vibrationValue';
  static const String _continueAfterAlarmKey = 'continueAfterAlarmValue';
  static const String _lastVisitedPageValueKey = 'lastVisitedPageValue';
  static const String _isDarkThemeKey = 'isDarkTheme';
  static const String _migrationCompletedKey = 'migrationFromSecureStorageCompleted';

  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<SharedPreferences> get _storage async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    await _migrateFromSecureStorage();
    return _prefs!;
  }

  @visibleForTesting
  static void resetForTesting() {
    _prefs = null;
  }

  static Future<void> _migrateFromSecureStorage() async {
    if (_prefs == null) return;

    final migrationCompleted = _prefs!.getBool(_migrationCompletedKey) ?? false;
    if (migrationCompleted) return;

    final allKeys = [
      _currentTimerValueKey,
      _startingTimerValueKey,
      _periodValueKey,
      _volumeValueKey,
      _screenLockValueKey,
      _alarmTypeValueKey,
      _languageValueKey,
      _vibrationValueKey,
      _continueAfterAlarmKey,
      _lastVisitedPageValueKey,
      _isDarkThemeKey,
    ];

    for (final key in allKeys) {
      try {
        final value = await _secureStorage.read(key: key);
        if (value != null) {
          await _prefs!.setString(key, value);
        }
      } catch (e) {
        continue;
      }
    }

    await _prefs!.setBool(_migrationCompletedKey, true);
  }

  static Future<SettingsData> settings() async {
    var volume = await volumeValue();
    var period = await periodValue();
    var screenLock = await screenLockValue();
    var alarmType = await alarmTypeValue();
    var language = await languageValue();
    var vibration = await vibrationValue();
    var continueAfterAlarm = await continueAfterAlarmValue();
    return SettingsData(volume, period, screenLock, alarmType, language, vibration, continueAfterAlarm);
  }

  static Future<TimerUserPreferences> timerData() async {
    var period = await periodValue();
    var screenLock = await screenLockValue();
    var startingTime = await startingTimerValue();
    var continueAfterAlarm = await continueAfterAlarmValue();
    return TimerUserPreferences(screenLock, startingTime, period, continueAfterAlarm);
  }

  static void storeCurrentTimerValue(Duration value) async {
    final prefs = await _storage;
    prefs.setString(_currentTimerValueKey, DurationToString.convert(value));
  }

  static Future<Duration> currentTimerValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_currentTimerValueKey) ?? "00:00";
    return StringToDuration.convert(value);
  }

  static void storeStartingTimerValue(Duration value) async {
    final prefs = await _storage;
    prefs.setString(_startingTimerValueKey, DurationToString.convert(value));
  }

  static Future<Duration> startingTimerValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_startingTimerValueKey) ?? "10:00";
    return StringToDuration.convert(value);
  }

  static void storePeriodValue(int value) async {
    final prefs = await _storage;
    prefs.setString(_periodValueKey, value.toString());
  }

  static Future<int> periodValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_periodValueKey) ?? "1";
    return int.parse(value);
  }

  static void storeVolumeValue(int value) async {
    var currentValue = await volumeValue();
    if (currentValue == value) return;
    VolumeController().setVolume(value / 100, showSystemUI: true);
    final prefs = await _storage;
    prefs.setString(_volumeValueKey, value.toString());
  }

  static Future<int> volumeValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_volumeValueKey) ?? "50";
    return int.parse(value);
  }

  static void storeScreenLockValue(bool value) async {
    WakelockPlus.toggle(enable: value);
    final prefs = await _storage;
    prefs.setString(_screenLockValueKey, value.toString());
  }

  static Future<bool> screenLockValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_screenLockValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeAlarmTypeValue(String value) async {
    final prefs = await _storage;
    prefs.setString(_alarmTypeValueKey, value);
    Speaker().playAlarmSound();
  }

  static Future<AlarmType> alarmTypeValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_alarmTypeValueKey);
    return AlarmType.values.firstWhere((alarm) => alarm.name == value, orElse: () => AlarmType.brass);
  }

  static void storeLanguageValue(String value) async {
    final prefs = await _storage;
    prefs.setString(_languageValueKey, value);
  }

  static Future<SupportedLanguage> languageValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_languageValueKey);
    if (value != null) {
      return SupportedLanguage.fromCode(value);
    }

    var systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    var language = SupportedLanguage.fromCode(systemLocale.languageCode);
    storeLanguageValue(language.code);
    return language;
  }

  static void storeVibrationValue(bool value) async {
    final prefs = await _storage;
    prefs.setString(_vibrationValueKey, value.toString());
  }

  static Future<bool> vibrationValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_vibrationValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeContinueAfterAlarmValue(bool value) async {
    final prefs = await _storage;
    prefs.setString(_continueAfterAlarmKey, value.toString());
  }

  static Future<bool> continueAfterAlarmValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_continueAfterAlarmKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeLastVisitedPageValue(AvailablePage value) async {
    final prefs = await _storage;
    prefs.setString(_lastVisitedPageValueKey, value.name);
  }

  static Future<AvailablePage> lastVisitedPageValue() async {
    final prefs = await _storage;
    var value = prefs.getString(_lastVisitedPageValueKey);
    return AvailablePage.values.firstWhere((val) => value == val.name, orElse: () => AvailablePage.clock);
  }

  static void storeIsDarkTheme(bool value) async {
    final prefs = await _storage;
    prefs.setString(_isDarkThemeKey, value.toString());
  }

  static Future<bool> isDarkTheme() async {
    final prefs = await _storage;
    var value = prefs.getString(_isDarkThemeKey) ?? "false";
    return value.toLowerCase() == 'true';
  }
}
