import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('pl')];

  /// No description provided for @appTitle.
  ///
  /// In pl, this message translates to:
  /// **'Atloud'**
  String get appTitle;

  /// No description provided for @timerTab.
  ///
  /// In pl, this message translates to:
  /// **'MINUTNIK'**
  String get timerTab;

  /// No description provided for @clockTab.
  ///
  /// In pl, this message translates to:
  /// **'ZEGAR'**
  String get clockTab;

  /// No description provided for @settingsTab.
  ///
  /// In pl, this message translates to:
  /// **'USTAWIENIA'**
  String get settingsTab;

  /// No description provided for @feedbackTab.
  ///
  /// In pl, this message translates to:
  /// **'OPINIA'**
  String get feedbackTab;

  /// No description provided for @start.
  ///
  /// In pl, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In pl, this message translates to:
  /// **'STOP'**
  String get stop;

  /// No description provided for @reset.
  ///
  /// In pl, this message translates to:
  /// **'RESET'**
  String get reset;

  /// No description provided for @minutes.
  ///
  /// In pl, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In pl, this message translates to:
  /// **'sek'**
  String get seconds;

  /// No description provided for @hours.
  ///
  /// In pl, this message translates to:
  /// **'godz'**
  String get hours;

  /// No description provided for @alarmSettings.
  ///
  /// In pl, this message translates to:
  /// **'Dźwięk alarmu'**
  String get alarmSettings;

  /// No description provided for @volumeSettings.
  ///
  /// In pl, this message translates to:
  /// **'Głośność'**
  String get volumeSettings;

  /// No description provided for @vibrationSettings.
  ///
  /// In pl, this message translates to:
  /// **'Wibracje'**
  String get vibrationSettings;

  /// No description provided for @screenLockSettings.
  ///
  /// In pl, this message translates to:
  /// **'Blokada ekranu'**
  String get screenLockSettings;

  /// No description provided for @continueAfterAlarm.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj odliczanie minutnika po czasie'**
  String get continueAfterAlarm;

  /// No description provided for @language.
  ///
  /// In pl, this message translates to:
  /// **'Język'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In pl, this message translates to:
  /// **'Ciemny motyw'**
  String get darkMode;

  /// No description provided for @feedback.
  ///
  /// In pl, this message translates to:
  /// **'Prześlij opinię'**
  String get feedback;

  /// No description provided for @version.
  ///
  /// In pl, this message translates to:
  /// **'Wersja'**
  String get version;

  /// No description provided for @periodSettings.
  ///
  /// In pl, this message translates to:
  /// **'Co ile minut'**
  String get periodSettings;

  /// No description provided for @automaticScreenLock.
  ///
  /// In pl, this message translates to:
  /// **'Automatyczna blokada ekranu'**
  String get automaticScreenLock;

  /// No description provided for @timeAnnouncement.
  ///
  /// In pl, this message translates to:
  /// **'Jest godzina {time}'**
  String timeAnnouncement(String time);

  /// No description provided for @polish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get polish;

  /// No description provided for @english.
  ///
  /// In pl, this message translates to:
  /// **'Angielski'**
  String get english;

  /// No description provided for @alarmBrass.
  ///
  /// In pl, this message translates to:
  /// **'ORKIESTRA'**
  String get alarmBrass;

  /// No description provided for @alarmFanfare.
  ///
  /// In pl, this message translates to:
  /// **'FANFARY'**
  String get alarmFanfare;

  /// No description provided for @alarmFight.
  ///
  /// In pl, this message translates to:
  /// **'WALKA'**
  String get alarmFight;

  /// No description provided for @alarmBonus.
  ///
  /// In pl, this message translates to:
  /// **'BONUS'**
  String get alarmBonus;

  /// No description provided for @alarmLevel.
  ///
  /// In pl, this message translates to:
  /// **'POZIOM'**
  String get alarmLevel;

  /// No description provided for @alarmReveille.
  ///
  /// In pl, this message translates to:
  /// **'POBUDKA'**
  String get alarmReveille;

  /// No description provided for @alarmTrombone.
  ///
  /// In pl, this message translates to:
  /// **'PUZON'**
  String get alarmTrombone;

  /// No description provided for @alarmUkulele.
  ///
  /// In pl, this message translates to:
  /// **'UKULELE'**
  String get alarmUkulele;

  /// No description provided for @feedbackTitle.
  ///
  /// In pl, this message translates to:
  /// **'OPINIA'**
  String get feedbackTitle;

  /// No description provided for @emailField.
  ///
  /// In pl, this message translates to:
  /// **'Adres e-mail'**
  String get emailField;

  /// No description provided for @appWorksField.
  ///
  /// In pl, this message translates to:
  /// **'Czy masz problem z aplikacją?'**
  String get appWorksField;

  /// No description provided for @featuresField.
  ///
  /// In pl, this message translates to:
  /// **'Jakie funkcje chciałbyś/chciałabyś abyśmy dodali?'**
  String get featuresField;

  /// No description provided for @sendButton.
  ///
  /// In pl, this message translates to:
  /// **'WYŚLIJ'**
  String get sendButton;

  /// No description provided for @thankYouMessage.
  ///
  /// In pl, this message translates to:
  /// **'Dziękujemy za Twoją opinię!'**
  String get thankYouMessage;

  /// No description provided for @fieldRequired.
  ///
  /// In pl, this message translates to:
  /// **'To pole jest wymagane'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź poprawny adres e-mail'**
  String get invalidEmail;

  /// No description provided for @deviceInfoNotAvailable.
  ///
  /// In pl, this message translates to:
  /// **'Device Info Not Available'**
  String get deviceInfoNotAvailable;

  /// No description provided for @contextNotAvailable.
  ///
  /// In pl, this message translates to:
  /// **'Context not available for MediaQuery'**
  String get contextNotAvailable;

  /// No description provided for @screenInfo.
  ///
  /// In pl, this message translates to:
  /// **'Ekran: {width}x{height} @{ratio}x'**
  String screenInfo(String width, String height, String ratio);

  /// No description provided for @androidVersion.
  ///
  /// In pl, this message translates to:
  /// **'Wersja androida: {version} (SDK {sdk})'**
  String androidVersion(String version, String sdk);

  /// No description provided for @deviceModel.
  ///
  /// In pl, this message translates to:
  /// **'Model: {model}'**
  String deviceModel(String model);

  /// No description provided for @errorGettingDeviceInfo.
  ///
  /// In pl, this message translates to:
  /// **'Error getting device info: {error}, {screenInfo}'**
  String errorGettingDeviceInfo(String error, String screenInfo);

  /// No description provided for @nextAnnouncementIn.
  ///
  /// In pl, this message translates to:
  /// **'Na głos co {minute} min'**
  String nextAnnouncementIn(String minute);

  /// No description provided for @airtableApiError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd API Airtable: {statusCode} {reasonPhrase}'**
  String airtableApiError(String statusCode, String reasonPhrase);

  /// No description provided for @airtableSendError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas wysyłania danych do AirTable: {error}'**
  String airtableSendError(String error);

  /// No description provided for @ratingDialogTitle1.
  ///
  /// In pl, this message translates to:
  /// **'Lubisz naszą aplikację? ⏰'**
  String get ratingDialogTitle1;

  /// No description provided for @ratingDialogContent1.
  ///
  /// In pl, this message translates to:
  /// **'Podziel się swoją opinią!\nKażda ocena pomaga nam tworzyć lepsze narzędzia.'**
  String get ratingDialogContent1;

  /// No description provided for @ratingDialogTitle2.
  ///
  /// In pl, this message translates to:
  /// **'Cieszymy się, że korzystasz z naszej aplikacji! 🌟'**
  String get ratingDialogTitle2;

  /// No description provided for @ratingDialogContent2.
  ///
  /// In pl, this message translates to:
  /// **'Dzięki ocenie pomagasz nam ją ulepszać :)'**
  String get ratingDialogContent2;

  /// No description provided for @ratingDialogTitle3.
  ///
  /// In pl, this message translates to:
  /// **'Hurra! 🎉 Ciągle z nami jesteś!'**
  String get ratingDialogTitle3;

  /// No description provided for @ratingDialogContent3.
  ///
  /// In pl, this message translates to:
  /// **'Prosimy o pozytywną ocenę abyśmy mogli dalej działać.'**
  String get ratingDialogContent3;

  /// No description provided for @ratingChoose.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz ocenę'**
  String get ratingChoose;

  /// No description provided for @ratingSubmit.
  ///
  /// In pl, this message translates to:
  /// **'PRZEŚLIJ OPINIĘ'**
  String get ratingSubmit;

  /// No description provided for @onboardingTitle1.
  ///
  /// In pl, this message translates to:
  /// **'Mówiący zegar i minutnik AtLoud'**
  String get onboardingTitle1;

  /// No description provided for @onboardingWelcome.
  ///
  /// In pl, this message translates to:
  /// **'Dziękujemy za instalację! 🎉'**
  String get onboardingWelcome;

  /// No description provided for @onboardingHappy.
  ///
  /// In pl, this message translates to:
  /// **'Cieszymy się, że jesteś z nami.'**
  String get onboardingHappy;

  /// No description provided for @onboardingTips.
  ///
  /// In pl, this message translates to:
  /// **'Oto kilka wskazówek na początek.'**
  String get onboardingTips;

  /// No description provided for @onboardingMuteClock.
  ///
  /// In pl, this message translates to:
  /// **'Możesz wyciszyć zegar, dotykając ikony głośnika na środku ekranu.'**
  String get onboardingMuteClock;

  /// No description provided for @onboardingMuteUseful.
  ///
  /// In pl, this message translates to:
  /// **'Przydatne w miejscach publicznych i w czasie nocy.'**
  String get onboardingMuteUseful;

  /// No description provided for @onboardingSetTimer.
  ///
  /// In pl, this message translates to:
  /// **'Aby ustawić minutnik, stuknij w cyfry na środku ekranu.'**
  String get onboardingSetTimer;

  /// No description provided for @onboardingSetTime.
  ///
  /// In pl, this message translates to:
  /// **'Następnie ustaw czas.'**
  String get onboardingSetTime;

  /// No description provided for @onboardingPermissions.
  ///
  /// In pl, this message translates to:
  /// **'Za chwilę poprosimy Cię o 2 zgody potrzebne do poprawnego działania aplikacji.'**
  String get onboardingPermissions;

  /// No description provided for @onboardingAccept.
  ///
  /// In pl, this message translates to:
  /// **'Prosimy, zaakceptuj je.'**
  String get onboardingAccept;

  /// No description provided for @onboardingEnjoy.
  ///
  /// In pl, this message translates to:
  /// **'Miłego korzystania! ⏰💛 Dziękujemy'**
  String get onboardingEnjoy;

  /// No description provided for @onboardingNext.
  ///
  /// In pl, this message translates to:
  /// **'DALEJ >>'**
  String get onboardingNext;

  /// No description provided for @batteryOptimizationTitle.
  ///
  /// In pl, this message translates to:
  /// **'Optymalizacja baterii włączona'**
  String get batteryOptimizationTitle;

  /// No description provided for @batteryOptimizationMessage.
  ///
  /// In pl, this message translates to:
  /// **'Optymalizacja baterii jest włączona dla tej aplikacji, co może uniemożliwić poprawne działanie usługi w tle. Wyłącz optymalizację baterii dla Atloud w ustawieniach urządzenia, aby zapewnić prawidłowe działanie.'**
  String get batteryOptimizationMessage;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @openSettings.
  ///
  /// In pl, this message translates to:
  /// **'Otwórz ustawienia'**
  String get openSettings;

  /// No description provided for @permissionsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wymagane zgody'**
  String get permissionsTitle;

  /// No description provided for @permissionNotifications.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia'**
  String get permissionNotifications;

  /// No description provided for @permissionBattery.
  ///
  /// In pl, this message translates to:
  /// **'Optymalizacja baterii'**
  String get permissionBattery;

  /// No description provided for @permissionGranted.
  ///
  /// In pl, this message translates to:
  /// **'Udzielono'**
  String get permissionGranted;

  /// No description provided for @permissionNotGranted.
  ///
  /// In pl, this message translates to:
  /// **'Nie udzielono'**
  String get permissionNotGranted;

  /// No description provided for @permissionGrant.
  ///
  /// In pl, this message translates to:
  /// **'USTAW'**
  String get permissionGrant;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
