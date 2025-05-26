import 'dart:async';

import 'package:atloud/main.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class MockAudioPlayersStreamHandler extends MockStreamHandler {
  @override
  Stream<dynamic>? onListen(dynamic arguments, MockStreamHandlerEventSink events) {
    return const Stream.empty();
  }

  @override
  void onCancel(dynamic arguments) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() async {
    await loadAppFonts();
    
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_foreground_task/methods'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'isRunningService':
            return false;
          case 'startService':
            return true;
          default:
            return null;
        }
      },
    );

    final Map<String, String> mockStorage = {
      'startingTimerValue': '05:00',
      'periodValue': '3', 
      'volumeValue': '75',
      'backgroundSoundValue': 'true',
      'screenLockValue': 'false',
      'alarmTypeValue': 'Brass',
      'languageValue': 'pl-PL',
      'vibrationValue': 'true',
      'continueAfterAlarmValue': 'false',
      'currentTimerValue': '05:00',
    };

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'read':
            final key = methodCall.arguments['key'] as String;
            return mockStorage[key];
          case 'write':
            final key = methodCall.arguments['key'] as String;
            final value = methodCall.arguments['value'] as String;
            mockStorage[key] = value;
            return null;
          case 'delete':
            final key = methodCall.arguments['key'] as String;
            mockStorage.remove(key);
            return null;
          case 'deleteAll':
            mockStorage.clear();
            return null;
          case 'readAll':
            return mockStorage;
          default:
            return null;
        }
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('xyz.luan/audioplayers/events'),
      MockAudioPlayersStreamHandler()
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller'),
      (MethodCall methodCall) async => 0.5,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/wakelock_plus'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/package_info'),
      (MethodCall methodCall) async => {
        'appName': 'Atloud',
        'packageName': 'com.example.atloud',
        'version': '1.0.0',
        'buildNumber': '1',
      },
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('com.kurenai7968.volume_controller.volume_listener_event'),
      (MethodCall methodCall) async => null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
      (dynamic message) async => StandardMessageCodec().encodeMessage(<String, dynamic>{}),
    );
  });

  group('Visual Regression Tests', () {
    final devices = [
      const Device(name: 'motorola_edge_30_ultra', size: Size(432, 936), devicePixelRatio: 2.5),
      const Device(name: 'pocophone_f1', size: Size(393, 769), devicePixelRatio: 2.8),
    ];
    for (final device in devices) {
      testWidgets('Timer page - ${device.name}', (WidgetTester tester) async {
        tester.view.physicalSize = Size(device.size.width * device.devicePixelRatio, device.size.height * device.devicePixelRatio);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(const MyApp(lastVisitedPage: AvailablePage.timer));
        await tester.pump(const Duration(seconds: 5));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${device.name}_timer_page.png'),
        );
      });

      testWidgets('Clock page - ${device.name}', (WidgetTester tester) async {
        tester.view.physicalSize = Size(device.size.width * device.devicePixelRatio, device.size.height * device.devicePixelRatio);
        addTearDown(tester.view.reset);

        await tester.pumpWidget(const MyApp(lastVisitedPage: AvailablePage.clock));
        await tester.pump(const Duration(seconds: 2));

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/${device.name}_clock_page.png'),
        );
      });
    }
  });
}
