import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/sound/alarm_type.dart';

class SettingsData {
  final int volumeValue;
  final int periodValue;
  final bool screenLockValue;
  final AlarmType alarmTypeValue;
  final SupportedLanguage languageValue;
  final bool vibrationValue;
  final bool continuationAfterAlarmValue;

  SettingsData(this.volumeValue, this.periodValue, this.screenLockValue, this.alarmTypeValue, this.languageValue, this.vibrationValue, this.continuationAfterAlarmValue);
}