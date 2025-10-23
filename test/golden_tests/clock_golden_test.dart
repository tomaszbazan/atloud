import 'package:atloud/main.dart';
import 'package:atloud/shared/available_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../test_helpers/mock_plugins.dart';

void main() {
  group('GoldenBuilder', () {
    testGoldens('Scenario Builder example', (tester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exception.toString().contains('audioplayers') ||
            details.exception.toString().contains('MissingPluginException')) {
          return;
        }
        FlutterError.presentError(details);
      };

      MockPlugins.setupMocks();
      final ratingService = MockRatingService();
      await loadAppFonts();
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone
        ])
        ..addScenario(
          widget: MyApp(lastVisitedPage: AvailablePage.timer, ratingService: ratingService),
          name: 'clock page',
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'clock_page' );

      MockPlugins.clearMocks();
    });
  });
}