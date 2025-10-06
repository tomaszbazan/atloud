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
      await loadAppFonts();
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone
        ])
        ..addScenario(
          widget: MyApp(lastVisitedPage: AvailablePage.timer),
          name: 'settings page',
          onCreate: (scenarioWidgetKey) async {
            final finder = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.byIcon(Icons.settings_outlined),
            );
            expect(finder, findsOneWidget);

            await tester.tap(finder);
          },
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(tester, 'settings_page' );

      MockPlugins.clearMocks();
    });
  });
}