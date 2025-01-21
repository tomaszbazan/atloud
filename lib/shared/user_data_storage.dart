import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/string_to_duration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../settings/settings_data.dart';

class UserDataStorage {
  static const String _currentTimerValueKey = 'currentTimerValue';
  static const String _startingTimerValueKey = 'startingTimerValue';
  static const String _volumeValueKey = 'volumeValue';
  static const String _periodValueKey = 'periodValue';
  static const String _backgroundSoundValueKey = 'backgroundSoundValue';
  static const String _screenLockValueKey = 'screenLockValue';
  static const String _alarmTypeValueKey = 'alarmTypeValue';
  static const String _languageValueKey = 'languageValue';
  static const String _vibrationValueKey = 'vibrationValue';
  static const String _continuationAfterTimeValueKey = 'continuationAfterTimeValue';
  static const String _soundOnValueKey = 'soundOnValue';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<SettingsData> settings() async {
    var volume = await volumeValue();
    var period = await periodValue();
    var backgroundSound = await backgroundSoundValue();
    var screenLock = await screenLockValue();
    var alarmType = await alarmTypeValue();
    var language = await languageValue();
    var vibration = await vibrationValue();
    var continueAfterTime = await continueAfterTimeValue();
    return SettingsData(volume, period, backgroundSound, screenLock, alarmType, language, vibration, continueAfterTime);
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
    var value = await _storage.read(key: _startingTimerValueKey) ?? "00:00";
    return StringToDuration.convert(value);
  }

  static void storeVolumeValue(double value) async {
    _storage.write(key: _volumeValueKey, value: value.toString());
  }

  static Future<double> volumeValue() async {
    var value = await _storage.read(key: _volumeValueKey) ?? "0";
    return double.parse(value);
  }

  static void storePeriodValue(int value) async {
    _storage.write(key: _periodValueKey, value: value.toString());
  }

  static Future<int> periodValue() async {
    var value = await _storage.read(key: _periodValueKey) ?? "1";
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

  static Future<String> alarmTypeValue() async {
    return await _storage.read(key: _alarmTypeValueKey) ?? "FANFARY";
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

  static void storeContinueAfterTimeValue(bool value) async {
    _storage.write(key: _continuationAfterTimeValueKey, value: value.toString());
  }

  static Future<bool> continueAfterTimeValue() async {
    var value = await _storage.read(key: _continuationAfterTimeValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }

  static void storeSoundOn(bool value) async {
    _storage.write(key: _soundOnValueKey, value: value.toString());
  }

  static Future<bool> soundOnValue() async {
    var value = await _storage.read(key: _soundOnValueKey) ?? "true";
    return value.toLowerCase() == 'true';
  }
}