import 'package:atloud/l10n/app_localizations.dart';

enum AlarmType {
  brass('sounds/alarms/brass.mp3'),
  fanfare('sounds/alarms/fanfare.mp3'),
  fight('sounds/alarms/fight.mp3'),
  bonus('sounds/alarms/game-bonus.mp3'),
  level('sounds/alarms/level-completed.mp3'),
  reveille('sounds/alarms/reveille.mp3'),
  trombone('sounds/alarms/trombone.mp3'),
  ukulele('sounds/alarms/ukulele.mp3');

  final String filePath;

  const AlarmType(this.filePath);

  String getDisplayName(AppLocalizations localizations) {
    switch (this) {
      case AlarmType.brass:
        return localizations.alarmBrass;
      case AlarmType.fanfare:
        return localizations.alarmFanfare;
      case AlarmType.fight:
        return localizations.alarmFight;
      case AlarmType.bonus:
        return localizations.alarmBonus;
      case AlarmType.level:
        return localizations.alarmLevel;
      case AlarmType.reveille:
        return localizations.alarmReveille;
      case AlarmType.trombone:
        return localizations.alarmTrombone;
      case AlarmType.ukulele:
        return localizations.alarmUkulele;
    }
  }

  @Deprecated('Use getDisplayName(localizations) instead')
  String get displayName => name.toUpperCase();
}
