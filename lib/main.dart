import 'package:atloud/foreground_task/foreground_task_initializer.dart';
import 'package:atloud/l10n/language_notifier.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/settings/settings.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/theme/theme.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:atloud/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  ForegroundTaskInitializer.initService();

  // var lastVisitedPage = await UserDataStorage.lastVisitedPageValue(); // TODO: Verify if it is working in all cases
  var lastVisitedPage = AvailablePage.clock;

  LanguageNotifier().loadLocale();
  runApp(MyApp(lastVisitedPage: lastVisitedPage));
}

class MyApp extends StatelessWidget {
  final AvailablePage lastVisitedPage;
  const MyApp({super.key, required this.lastVisitedPage});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageNotifier(),
      builder: (context, child) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return MaterialApp(
          title: 'Atloud',
          theme: CustomTheme.lightTheme,
          locale: LanguageNotifier().locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: SupportedLanguage.supportedLocales,
          home: TimerPage(isTimerPage: lastVisitedPage == AvailablePage.timer ? true : false),
          routes: {
            '/timer': (context) => const TimerPage(isTimerPage: true),
            '/clock': (context) => const TimerPage(isTimerPage: false),
            '/settings': (context) => const SettingsPage(),
          },
        );
      },
    );
  }
}