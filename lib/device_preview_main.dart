import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/rating/rating_service.dart';
import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/theme.dart';
import 'package:atloud/theme/theme_notifier.dart';
import 'package:atloud/timer/timer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_initializer.dart';
import 'l10n/language_notifier.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(ratingService: RatingService()),
    storage: DevicePreviewStorage.preferences(),
  ),
);

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
          home: AppInitializer(ratingService: widget.ratingService),
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