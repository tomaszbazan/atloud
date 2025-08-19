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
  static void startService(receivedServiceData) async {
    // Without this block service is not starting
    if (await FlutterForegroundTask.isRunningService) {}
    FlutterForegroundTask.addTaskDataCallback(receivedServiceData);
    var languageCode = await UserDataStorage.languageValue();
    var language = SupportedLanguage.fromCode(languageCode);

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

  static String notificationText(language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Naciśnij aby powrócić do aplikacji';
      case SupportedLanguage.english:
        return 'Press to return to the application';
      default:
        return 'Press to return to the application';
    }
  }

  static String stopButtonText(language) {
    switch (language) {
      case SupportedLanguage.polish:
        return 'Zatrzymaj';
      case SupportedLanguage.english:
        return 'Stop';
      default:
        return 'Stop';
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }
}