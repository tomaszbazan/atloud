import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPlugins {
  static void setupMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_foreground_task/methods'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isRunningService':
            return false;
          case 'startService':
            return true;
          case 'stopService':
            return true;
          case 'sendDataToTask':
            return null;
          case 'sendDataToMain':
            return null;
          case 'addTaskDataCallback':
            return null;
          case 'removeTaskDataCallback':
            return null;
          default:
            return null;
        }
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'read':
            // Mock specific keys for deterministic golden tests
            if (methodCall.arguments != null && methodCall.arguments is Map) {
              final args = methodCall.arguments as Map;
              final key = args['key'];
              switch (key) {
                case 'startingTimerValue':
                  return '05:00'; // 5 minutes starting time
                case 'periodValue':
                  return '60'; // 1 minute period as string
                case 'continueAfterAlarmValue':
                  return 'false'; // boolean as string
                case 'screenLockValue':
                  return 'false'; // boolean as string
                case 'languageValue':
                  return 'pl-PL'; // supported language code
                default:
                  return null;
              }
            }
            return null;
          case 'write':
          case 'delete':
          case 'deleteAll':
          case 'readAll':
            return null;
          default:
            return null;
        }
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller.volume_listener_event'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller.volume_listener'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'init':
            return null;
          case 'changeLogLevel':
            return null;
          default:
            return null;
        }
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('xyz.luan/audioplayers.global/events'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'create':
            return null;
          case 'dispose':
            return null;
          case 'play':
            return null;
          case 'stop':
            return null;
          case 'pause':
            return null;
          case 'seek':
            return null;
          case 'setVolume':
            return null;
          case 'setPlaybackRate':
            return null;
          case 'setSourceUrl':
            return null;
          default:
            return null;
        }
      },
    );

    // Mock WakelockPlus using ServicesBinding
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      (data) async => const StandardMessageCodec().encodeMessage([null]),
    );

    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.isEnabled',
      (data) async => const StandardMessageCodec().encodeMessage([false]),
    );
  }

  static void clearMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_foreground_task/methods'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller.volume_listener_event'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller.volume_listener'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('xyz.luan/audioplayers.global/events'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      null,
    );

    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      null,
    );

    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.isEnabled',
      null,
    );
  }
}
