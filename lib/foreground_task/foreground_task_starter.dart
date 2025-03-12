import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'clock_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ClockTaskHandler());
}

class ForegroundTaskStarter {
  static Future<ServiceRequestResult> startService(receivedServiceData) async {
    FlutterForegroundTask.addTaskDataCallback(receivedServiceData);

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 8881,
        notificationTitle: 'At Loud!',
        notificationText: 'Naciśnij aby powrócić do aplikacji',
        notificationIcon: const NotificationIcon(metaDataName: 'pl.btsoftware.atloud.default_notification_icon', backgroundColor: Colors.black),
        notificationInitialRoute: '/clock',
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }
}