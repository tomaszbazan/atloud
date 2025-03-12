import 'package:atloud/foreground_task/foreground_task_initializer.dart';
import 'package:atloud/settings/settings.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'clock/clock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  ForegroundTaskInitializer.initService();

  var lastVisitedPage = await UserDataStorage.lastVisitedPageValue();

  runApp(MyApp(lastVisitedPage: lastVisitedPage));
}

class MyApp extends StatelessWidget {
  final AvailablePage lastVisitedPage;
  const MyApp({super.key, required this.lastVisitedPage});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Atloud',
      theme: CustomTheme.lightTheme,
      home: const TimerPage(isTimerPage: false),
      routes: {
        '/timer': (context) => TimerPage(isTimerPage: true),
        '/clock': (context) => const ClockPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}