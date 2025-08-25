import 'package:atloud/components/app_bar.dart';
import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/settings/alarm_type_setting.dart';
import 'package:atloud/settings/boolean_widget.dart';
import 'package:atloud/settings/language_setting.dart';
import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/settings/settings_icon.dart';
import 'package:atloud/settings/slider_widget.dart';
import 'package:atloud/settings/theme_setting.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/footer.dart';
import '../shared/available_page.dart';
import '../shared/user_data_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _versionCounter = 0;

  Future<SettingsData> _loadPreferences() async {
    return UserDataStorage.settings();
  }

  void _incrementShowVersionCounter() {
    _versionCounter++;
    if (_versionCounter >= 5) {
      _displayAppVersion();
    }
  }

  void _displayAppVersion() async {
    var version = await _appVersion();
    if (mounted) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${localizations.version} $version'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<String> _appVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarWidget(text: localizations.settingsTab.toUpperCase(), incrementShowVersionCounter: _incrementShowVersionCounter),
      body: FutureBuilder<SettingsData>(
        future: _loadPreferences(),
        builder: (BuildContext context, AsyncSnapshot<SettingsData> snapshot) {
          if (snapshot.hasData) {
            SettingsData data = snapshot.requireData;
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SettingsIcon(constraints: constraints, incrementShowVersionCounter: _incrementShowVersionCounter),
                              SliderWidget(icon: Icons.volume_up, label: localizations.volumeSettings, min: 0, max: 100, value: data.volumeValue, onChange: (value) => UserDataStorage.storeVolumeValue(value)),
                              SliderWidget(icon: Icons.play_circle_outline, label: localizations.periodSettings, min: 1, max: 60, value: data.periodValue, onChange: (value) => UserDataStorage.storePeriodValue(value)),
                              AlarmTypeSetting(data: data, setState: setState),
                              LanguageSetting(data: data, setState: setState),
                              const ThemeSetting(),
                              BooleanWidget(label: localizations.continueAfterAlarm, value: data.continuationAfterAlarmValue, onChange: (value) => UserDataStorage.storeContinueAfterAlarmValue(value)),
                              BooleanWidget(label: localizations.vibrationSettings, value: data.vibrationValue, onChange: (value) => UserDataStorage.storeVibrationValue(value)),
                              BooleanWidget(label: localizations.screenLockSettings, value: data.screenLockValue, onChange: (value) => UserDataStorage.storeScreenLockValue(value)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const FooterWidget(currentPage: AvailablePage.settings),
    );
  }
}
