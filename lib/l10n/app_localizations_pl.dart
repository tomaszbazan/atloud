// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Atloud';

  @override
  String get timerTab => 'MINUTNIK';

  @override
  String get clockTab => 'ZEGAR';

  @override
  String get settingsTab => 'USTAWIENIA';

  @override
  String get feedbackTab => 'OPINIA';

  @override
  String get start => 'START';

  @override
  String get stop => 'STOP';

  @override
  String get reset => 'RESET';

  @override
  String get minutes => 'min';

  @override
  String get seconds => 'sek';

  @override
  String get hours => 'godz';

  @override
  String get alarmSettings => 'Dźwięk alarmu';

  @override
  String get volumeSettings => 'Głośność';

  @override
  String get vibrationSettings => 'Wibracje';

  @override
  String get screenLockSettings => 'Blokada ekranu';

  @override
  String get continueAfterAlarm => 'Kontynuuj odliczanie minutnika po czasie';

  @override
  String get language => 'Język';

  @override
  String get feedback => 'Prześlij opinię';

  @override
  String get version => 'Wersja';

  @override
  String get periodSettings => 'Co ile minut';

  @override
  String get automaticScreenLock => 'Automatyczna blokada ekranu';

  @override
  String timeAnnouncement(String time) {
    return 'Jest godzina $time';
  }

  @override
  String get polish => 'Polski';

  @override
  String get english => 'Angielski';

  @override
  String get alarmBrass => 'ORKIESTRA';

  @override
  String get alarmFanfare => 'FANFARY';

  @override
  String get alarmFight => 'WALKA';

  @override
  String get alarmBonus => 'BONUS';

  @override
  String get alarmLevel => 'POZIOM';

  @override
  String get alarmReveille => 'POBUDKA';

  @override
  String get alarmTrombone => 'PUZON';

  @override
  String get alarmUkulele => 'UKULELE';

  @override
  String get feedbackTitle => 'OPINIA';

  @override
  String get emailField => 'Adres e-mail';

  @override
  String get appWorksField => 'Czy masz problem z aplikacją?';

  @override
  String get featuresField =>
      'Jakie funkcje chciałbyś/chciałabyś abyśmy dodali?';

  @override
  String get sendButton => 'WYŚLIJ';

  @override
  String get thankYouMessage => 'Dziękujemy za Twoją opinię!';

  @override
  String get fieldRequired => 'To pole jest wymagane';

  @override
  String get invalidEmail => 'Wprowadź poprawny adres e-mail';

  @override
  String get deviceInfoNotAvailable => 'Device Info Not Available';

  @override
  String get contextNotAvailable => 'Context not available for MediaQuery';

  @override
  String screenInfo(String width, String height, String ratio) {
    return 'Ekran: ${width}x$height @${ratio}x';
  }

  @override
  String androidVersion(String version, String sdk) {
    return 'Wersja androida: $version (SDK $sdk)';
  }

  @override
  String deviceModel(String model) {
    return 'Model: $model';
  }

  @override
  String errorGettingDeviceInfo(String error, String screenInfo) {
    return 'Error getting device info: $error, $screenInfo';
  }
}
