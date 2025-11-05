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
  String get darkMode => 'Ciemny motyw';

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
  String get featuresField => 'Jakie funkcje chciałbyś/chciałabyś abyśmy dodali?';

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

  @override
  String nextAnnouncementIn(String minute) {
    return 'Na głos co $minute min';
  }

  @override
  String airtableApiError(String statusCode, String reasonPhrase) {
    return 'Błąd API Airtable: $statusCode $reasonPhrase';
  }

  @override
  String airtableSendError(String error) {
    return 'Błąd podczas wysyłania danych do AirTable: $error';
  }

  @override
  String get ratingDialogTitle1 => 'Lubisz naszą aplikację? ⏰';

  @override
  String get ratingDialogContent1 => 'Podziel się swoją opinią!\nKażda ocena pomaga nam tworzyć lepsze narzędzia.';

  @override
  String get ratingDialogTitle2 => 'Cieszymy się, że korzystasz z naszej aplikacji! 🌟';

  @override
  String get ratingDialogContent2 => 'Dzięki ocenie pomagasz nam ją ulepszać :)';

  @override
  String get ratingDialogTitle3 => 'Hurra! 🎉 Ciągle z nami jesteś!';

  @override
  String get ratingDialogContent3 => 'Prosimy o pozytywną ocenę abyśmy mogli dalej działać.';

  @override
  String get ratingChoose => 'Wybierz ocenę';

  @override
  String get ratingSubmit => 'PRZEŚLIJ OPINIĘ';

  @override
  String get onboardingTitle1 => 'Mówiący zegar i minutnik AtLoud';

  @override
  String get onboardingWelcome => 'Dziękujemy za instalację! 🎉';

  @override
  String get onboardingHappy => 'Cieszymy się, że jesteś z nami.';

  @override
  String get onboardingTips => 'Oto kilka wskazówek na początek.';

  @override
  String get onboardingMuteClock => 'Możesz wyciszyć zegar, dotykając ikony głośnika na środku ekranu.';

  @override
  String get onboardingMuteUseful => 'Przydatne w miejscach publicznych i w czasie nocy.';

  @override
  String get onboardingSetTimer => 'Aby ustawić minutnik, stuknij w cyfry na środku ekranu.';

  @override
  String get onboardingSetTime => 'Następnie ustaw czas.';

  @override
  String get onboardingPermissions => 'Za chwilę poprosimy Cię o 2 zgody potrzebne do poprawnego działania aplikacji.';

  @override
  String get onboardingAccept => 'Prosimy, zaakceptuj je.';

  @override
  String get onboardingEnjoy => 'Miłego korzystania! ⏰💛 Dziękujemy';

  @override
  String get onboardingNext => 'DALEJ >>';

  @override
  String get batteryOptimizationTitle => 'Optymalizacja baterii włączona';

  @override
  String get batteryOptimizationMessage =>
      'Optymalizacja baterii jest włączona dla tej aplikacji, co może uniemożliwić poprawne działanie usługi w tle. Wyłącz optymalizację baterii dla Atloud w ustawieniach urządzenia, aby zapewnić prawidłowe działanie.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get permissionsTitle => 'Wymagane zgody';

  @override
  String get permissionNotifications => 'Powiadomienia';

  @override
  String get permissionBattery => 'Optymalizacja baterii';

  @override
  String get permissionGranted => 'Udzielono';

  @override
  String get permissionNotGranted => 'Nie udzielono';

  @override
  String get permissionGrant => 'USTAW';
}
