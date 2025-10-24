import 'package:atloud/foreground_task/foreground_task_initializer.dart';
import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/l10n/language_notifier.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/rating/rating_service.dart';
import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/theme.dart';
import 'package:atloud/theme/theme_notifier.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  ForegroundTaskInitializer.initService();

  final ratingService = RatingService();
  await ratingService.incrementAppLaunchCount();

  LanguageNotifier().loadLocale();
  ThemeNotifier().loadTheme();
  runApp(MyApp(
    ratingService: ratingService,
  ));
}

class MyApp extends StatefulWidget {
  final RatingService ratingService;

  const MyApp({super.key, required this.ratingService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _checkAndShowRatingDialog();
  }

  Future<void> _checkAndShowRatingDialog() async {
    if (await widget.ratingService.shouldShowRatingDialog()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_navigatorKey.currentContext != null) {
          widget.ratingService.showRatingDialog(_navigatorKey.currentContext!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([LanguageNotifier(), ThemeNotifier()]),
      builder: (context, child) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Atloud',
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: ThemeNotifier().themeMode,
          locale: LanguageNotifier().locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: SupportedLanguage.supportedLocales,
          home: TimerPage(isTimerPage: false),
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
