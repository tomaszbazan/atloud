
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, String> setupMockPlatformChannels() {
  final Map<String, String> secureStorage = {};

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'read':
          final args = methodCall.arguments as Map;
          final key = args['key'] as String;
          return secureStorage[key];
        case 'write':
          final args = methodCall.arguments as Map;
          final key = args['key'] as String;
          final value = args['value'] as String;
          secureStorage[key] = value;
          return null;
        case 'delete':
          final args = methodCall.arguments as Map;
          final key = args['key'] as String;
          secureStorage.remove(key);
          return null;
        case 'deleteAll':
          secureStorage.clear();
          return null;
        case 'readAll':
          return secureStorage;
        default:
          return null;
      }
    },
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.kurenai7968.volume_controller.method'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'setVolume':
          return null;
        case 'getVolume':
          return 0.5;
        default:
          return null;
      }
    },
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.kurenai7968.volume_controller.volume_listener'),
    (MethodCall methodCall) async => null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.kurenai7968.volume_controller.volume_listener_event'),
    (MethodCall methodCall) async => null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getTemporaryDirectory':
          return '/tmp';
        case 'getApplicationDocumentsDirectory':
          return '/tmp/docs';
        default:
          return null;
      }
    },
  );

  ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
    (data) async => const StandardMessageCodec().encodeMessage([null]),
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers.global'),
    (MethodCall methodCall) async => null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers'),
    (MethodCall methodCall) async => null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockStreamHandler(
    const EventChannel('xyz.luan/audioplayers.global/events'),
    null,
  );

  return secureStorage;
}

void tearDownMockPlatformChannels() {
  const channels = [
    'plugins.it_nomads.com/flutter_secure_storage',
    'com.kurenai7968.volume_controller.method',
    'com.kurenai7968.volume_controller.volume_listener',
    'com.kurenai7968.volume_controller.volume_listener_event',
    'plugins.flutter.io/path_provider',
    'xyz.luan/audioplayers.global',
    'xyz.luan/audioplayers',
  ];

  for (final channel in channels) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      MethodChannel(channel),
      null,
    );
  }

  ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
    null,
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockStreamHandler(
    const EventChannel('xyz.luan/audioplayers.global/events'),
    null,
  );
}
