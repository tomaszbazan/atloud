import 'package:atloud/foreground_task/timer_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../l10n/supported_language.dart';
import '../shared/user_data_storage.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler());
}

class ForegroundTaskStarter {
  static void startService(Function(dynamic) receivedServiceData) async {
    // Without this block service is not starting
    if (await FlutterForegroundTask.isRunningService) {}
    FlutterForegroundTask.addTaskDataCallback(receivedServiceData);
    var language = await UserDataStorage.languageValue();

    FlutterForegroundTask.startService(
        serviceId: 8882,
        notificationTitle: 'At Loud!',
        notificationText: notificationText(language),
        notificationIcon: const NotificationIcon(
            metaDataName: 'pl.btsoftware.atloud.default_notification_icon',
            backgroundColor: Colors.black),
        notificationInitialRoute: '/clock',
        callback: startCallback,
        notificationButtons: [
          NotificationButton(
              id: TimerTaskHandler.stopButtonId, text: stopButtonText(language))
        ]
    );
  }

  static String notificationText(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Naciśnij aby powrócić do aplikacji';
      case SupportedLanguage.english:
        return 'Press to return to the application';
    }
  }

  static String stopButtonText(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Zatrzymaj';
      case SupportedLanguage.english:
        return 'Stop';
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }
}