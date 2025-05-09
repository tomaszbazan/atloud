import 'package:atloud/theme/theme.dart';
import 'package:atloud/timer/timer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'foreground_task/foreground_task_initializer.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
    storage: DevicePreviewStorage.preferences(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    WidgetsFlutterBinding.ensureInitialized();
    FlutterForegroundTask.initCommunicationPort();
    ForegroundTaskInitializer.initService();
    return MaterialApp(
      title: 'Atloud',
      theme: CustomTheme.lightTheme,
      home: const TimerPage(isTimerPage: true),
    );
  }
}