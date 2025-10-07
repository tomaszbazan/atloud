import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:atloud/sound/speaker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

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
    _storage.write(key: _currentTimerValueKey, value: DurationToString.convert(value));
  }

  static Future<Duration> currentTimerValue() async {
    var value = await _storage.read(key: _currentTimerValueKey) ?? "00:00";
    return StringToDuration.convert(value);
  }

  static void storeStartingTimerValue(Duration value) async {
    _storage.write(key: _startingTimerValueKey, value: DurationToString.convert(value));
  }

  static Future<Duration> startingTimerValue() async {
    var value = await _storage.read(key: _startingTimerValueKey) ?? "10:00";
    return StringToDuration.convert(value);
  }

  static void storePeriodValue(int value) async {
    _storage.write(key: _periodValueKey, value: value.toString());
  }

  static Future<int> periodValue() async {
    var value = await _storage.read(key: _periodValueKey) ?? "1";
    return int.parse(value);
  }

  static void storeVolumeValue(int value) async {
    var currentValue = await volumeValue();
    if (currentValue == value) return;
    VolumeController().setVolume(value / 100, showSystemUI: true);
    _storage.write(key: _volumeValueKey, value: value.toString());
  }

  static Future<int> volumeValue() async {
    var value = await _storage.read(key: _volumeValueKey) ?? "50";
    return int.parse(value);
  }

  static void storeScreenLockValue(bool value) async {
    WakelockPlus.toggle(enable: value);
    _storage.write(key: _screenLockValueKey, value: value.toString());
  }

  static Future<bool> screenLockValue() async {
    var value = await _storage.read(key: _screenLockValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeAlarmTypeValue(String value) async {
    _storage.write(key: _alarmTypeValueKey, value: value);
    Speaker().playAlarmSound(); // Play sound to notify user of change
  }

  static Future<AlarmType> alarmTypeValue() async {
    var value = await _storage.read(key: _alarmTypeValueKey);
    return AlarmType.values.firstWhere((alarm) => alarm.name == value, orElse: () => AlarmType.brass);
  }

  static void storeLanguageValue(String value) async {
    _storage.write(key: _languageValueKey, value: value);
  }

  static Future<SupportedLanguage> languageValue() async {
    var value = await _storage.read(key: _languageValueKey);
    if (value != null) {
      return SupportedLanguage.fromCode(value);
    }

    var systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    var language = SupportedLanguage.fromCode(systemLocale.languageCode);
    storeLanguageValue(language.code);
    return language;
  }

  static void storeVibrationValue(bool value) async {
    _storage.write(key: _vibrationValueKey, value: value.toString());
  }

  static Future<bool> vibrationValue() async {
    var value = await _storage.read(key: _vibrationValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeContinueAfterAlarmValue(bool value) async {
    _storage.write(key: _continueAfterAlarmKey, value: value.toString());
  }

  static Future<bool> continueAfterAlarmValue() async {
    var value = await _storage.read(key: _continueAfterAlarmKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeLastVisitedPageValue(AvailablePage value) async {
    _storage.write(key: _lastVisitedPageValueKey, value: value.name);
  }

  static Future<AvailablePage> lastVisitedPageValue() async {
    var value = await _storage.read(key: _lastVisitedPageValueKey);
    return AvailablePage.values.firstWhere((val) => value == val.name, orElse: () => AvailablePage.clock);
  }

  static void storeIsDarkTheme(bool value) async {
    _storage.write(key: _isDarkThemeKey, value: value.toString());
  }

  static Future<bool> isDarkTheme() async {
    var value = await _storage.read(key: _isDarkThemeKey) ?? "false";
    return value.toLowerCase() == 'true';
  }
}
