import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../settings/settings_data.dart';
import '../timer/timer_data.dart';

class UserDataStorage {
  static const String _currentTimerValueKey = 'currentTimerValue';
  static const String _startingTimerValueKey = 'startingTimerValue';
  static const String _periodValueKey = 'periodValue';
  static const String _volumeValueKey = 'volumeValue';
  static const String _backgroundSoundValueKey = 'backgroundSoundValue';
  static const String _screenLockValueKey = 'screenLockValue';
  static const String _alarmTypeValueKey = 'alarmTypeValue';
  static const String _languageValueKey = 'languageValue';
  static const String _vibrationValueKey = 'vibrationValue';
  static const String _continueAfterAlarmKey = 'continueAfterAlarmValue';
  static const String _lastVisitedPageValueKey = 'lastVisitedPageValue';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<SettingsData> settings() async {
    var volume = await volumeValue();
    var period = await periodValue();
    var backgroundSound = await backgroundSoundValue();
    var screenLock = await screenLockValue();
    var alarmType = await alarmTypeValue();
    var language = await languageValue();
    var vibration = await vibrationValue();
    var continueAfterAlarm = await continueAfterAlarmValue();
    return SettingsData(volume, period, backgroundSound, screenLock, alarmType, language, vibration, continueAfterAlarm);
  }

  static Future<TimerData> timerData() async {
    var period = await periodValue();
    var screenLock = await screenLockValue();
    var startingTime = await startingTimerValue();
    var continueAfterAlarm = await continueAfterAlarmValue();
    return TimerData(screenLock, startingTime, period, continueAfterAlarm);
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
    VolumeController().setVolume(value / 100, showSystemUI: true);
    _storage.write(key: _volumeValueKey, value: value.toString());
  }

  static Future<int> volumeValue() async {
    var value = await _storage.read(key: _volumeValueKey) ?? "50";
    return int.parse(value);
  }

  static void storeBackgroundSoundValue(bool value) async {
    _storage.write(key: _backgroundSoundValueKey, value: value.toString());
  }

  static Future<bool> backgroundSoundValue() async {
    var value = await _storage.read(key: _backgroundSoundValueKey) ?? "true";
    return value.toLowerCase() == 'true';
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
  }

  static Future<AlarmType> alarmTypeValue() async {
    var value = await _storage.read(key: _alarmTypeValueKey);
    return AlarmType.values.firstWhere((alarm) => alarm.displayName == value, orElse: () => AlarmType.brass);
  }

  static void storeLanguageValue(String value) async {
    _storage.write(key: _languageValueKey, value: value);
  }

  static Future<String> languageValue() async {
    return await _storage.read(key: _languageValueKey) ?? "pl-PL";
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
}