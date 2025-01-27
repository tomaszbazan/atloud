import 'package:atloud/sound/alarm_type.dart';

class SettingsData {
  final double volumeValue;
  final int periodValue;
  final bool backgroundSoundValue;
  final bool screenLockValue;
  final AlarmType alarmTypeValue;
  final String languageValue;
  final bool vibrationValue;
  final bool continuationAfterTimeValue;

  SettingsData(this.volumeValue, this.periodValue, this.backgroundSoundValue, this.screenLockValue, this.alarmTypeValue, this.languageValue, this.vibrationValue, this.continuationAfterTimeValue);
}