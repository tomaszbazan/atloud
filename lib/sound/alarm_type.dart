enum AlarmType {
  brass('OKRIESTRA', 'sounds/alarms/brass.mp3'),
  fanfare('FANFARY', 'sounds/alarms/fanfare.mp3'),
  fight('WALKA', 'sounds/alarms/fight.mp3'),
  bonus('BONUS', 'sounds/alarms/game-bonus.mp3'),
  level('POZIOM', 'sounds/alarms/level-completed.mp3'),
  reveille('POBUDKA', 'sounds/alarms/reveille.mp3'),
  trombone('PUZON', 'sounds/alarms/trombone.mp3'),
  ukulele('UKULELE', 'sounds/alarms/ukulele.mp3');

  final String displayName;
  final String filePath;

  const AlarmType(this.displayName, this.filePath);
}
