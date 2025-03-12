import 'package:atloud/sound/speaker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../sound/alarm_type.dart';

enum TaskType { timer, clock }

class ClockTaskHandler extends TaskHandler {
  static const String setTimerCommand = 'setTimer';
  static const String setClockCommand = 'setClock';
  // final _speaker = Speaker();
  // final service = FlutterBackgroundService();
  // static const MethodChannel _channel = MethodChannel('foreground_audio');
  var _taskType = TaskType.clock;

  var _seconds = 0;

  // ClockTaskHandler(TaskType type) {
  //   _taskType = type;
  // }

  Future<void> _incrementTime() async {
    _seconds++;

    if(_taskType != null) {
      print('$_taskType $_seconds');
    }

    // if (_seconds % 10 == 0) {
    //   print('test');

      // var alarmType = AlarmType.brass;
      // var alarm = AssetSource(alarmType.filePath);
      // audioPlayer.play(alarm);
      // service.invoke('play_sound');
      // _speaker.currentTime();
      // try {
      //   await _channel.invokeMethod('play_audio');
      // } catch (e) {
      //   print('Error playing audio: $e');
      // }
    // }

    // if (_seconds % 10 == 5) {
      // audioPlayer.stop();
    // }

    print('taskType: $_taskType');

    FlutterForegroundTask.updateService(
      notificationTitle: 'At Loud! - Clock - $_seconds',
      notificationIcon: const NotificationIcon(metaDataName: 'pl.btsoftware.atloud.default_notification_icon', backgroundColor: Colors.black),
      notificationInitialRoute: '/clock'
    );

    FlutterForegroundTask.sendDataToMain(_seconds);
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("onStart");
    if(_taskType == TaskType.clock) {
      var speaker = Speaker();
      speaker.currentTime();
    }
    _incrementTime();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    print(timestamp);
    if (timestamp.second == 0 && _taskType == TaskType.clock) {
      print("${timestamp.second} - speaker");
      var speaker = Speaker();
      speaker.currentTime();
    }
    _incrementTime();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('onDestroy');
  }

  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
    _taskType = _taskType == TaskType.clock ? TaskType.timer : TaskType.clock;
    print('onReceiveData: $_taskType');
    // if (data.toString() == setTimerCommand) {
    //   print('isTimer = true');
    //   _taskType = TaskType.timer;
    // }
    // if (data.toString() == setClockCommand) {
    //   print('isTimer = false');
    //   _taskType = TaskType.clock;
    // }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    // FlutterForegroundTask.sendDataToMain(DateTime.now());
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }
}