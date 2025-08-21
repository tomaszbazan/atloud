// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Atloud';

  @override
  String get timerTab => 'TIMER';

  @override
  String get clockTab => 'CLOCK';

  @override
  String get settingsTab => 'SETTINGS';

  @override
  String get feedbackTab => 'FEEDBACK';

  @override
  String get start => 'START';

  @override
  String get stop => 'STOP';

  @override
  String get reset => 'RESET';

  @override
  String get minutes => 'min';

  @override
  String get seconds => 'sec';

  @override
  String get hours => 'hrs';

  @override
  String get alarmSettings => 'Alarm sound';

  @override
  String get volumeSettings => 'Volume';

  @override
  String get vibrationSettings => 'Vibration';

  @override
  String get screenLockSettings => 'Screen lock';

  @override
  String get continueAfterAlarm => 'Continue timer countdown after time';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark theme';

  @override
  String get feedback => 'Send feedback';

  @override
  String get version => 'Version';

  @override
  String get periodSettings => 'Every how many minutes';

  @override
  String get automaticScreenLock => 'Automatic screen lock';

  @override
  String timeAnnouncement(String time) {
    return 'It is $time o\'clock';
  }

  @override
  String get polish => 'Polish';

  @override
  String get english => 'English';

  @override
  String get alarmBrass => 'BRASS';

  @override
  String get alarmFanfare => 'FANFARE';

  @override
  String get alarmFight => 'FIGHT';

  @override
  String get alarmBonus => 'BONUS';

  @override
  String get alarmLevel => 'LEVEL';

  @override
  String get alarmReveille => 'REVEILLE';

  @override
  String get alarmTrombone => 'TROMBONE';

  @override
  String get alarmUkulele => 'UKULELE';

  @override
  String get feedbackTitle => 'FEEDBACK';

  @override
  String get emailField => 'Email address';

  @override
  String get appWorksField => 'Do you have any problems with the app?';

  @override
  String get featuresField => 'What features would you like us to add?';

  @override
  String get sendButton => 'SEND';

  @override
  String get thankYouMessage => 'Thank you for your feedback!';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get deviceInfoNotAvailable => 'Device Info Not Available';

  @override
  String get contextNotAvailable => 'Context not available for MediaQuery';

  @override
  String screenInfo(String width, String height, String ratio) {
    return 'Screen: ${width}x$height @${ratio}x';
  }

  @override
  String androidVersion(String version, String sdk) {
    return 'Android version: $version (SDK $sdk)';
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
