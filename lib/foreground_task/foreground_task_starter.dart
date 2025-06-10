import 'package:atloud/foreground_task/timer_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler());
}

class ForegroundTaskStarter {
  static void startService(receivedServiceData) async {
    // Without this block service is not starting
    if (await FlutterForegroundTask.isRunningService) {
    }
    FlutterForegroundTask.addTaskDataCallback(receivedServiceData);
    FlutterForegroundTask.startService(
      serviceId: 8882,
      notificationTitle: 'At Loud!',
      notificationText: 'Naciśnij aby powrócić do aplikacji',
      notificationIcon: const NotificationIcon(metaDataName: 'pl.btsoftware.atloud.default_notification_icon', backgroundColor: Colors.black),
      notificationInitialRoute: '/clock',
      callback: startCallback,
      notificationButtons: [const NotificationButton(id: TimerTaskHandler.stopButtonId, text: 'Zatrzymaj')]
    );
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }
}