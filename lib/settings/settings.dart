import 'package:atloud/components/app_bar.dart';
import 'package:atloud/settings/alarm_type_setting.dart';
import 'package:atloud/settings/background_sound_setting.dart';
import 'package:atloud/settings/continue_after_alarm_setting.dart';
import 'package:atloud/settings/period_setting.dart';
import 'package:atloud/settings/screen_lock_setting.dart';
import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/settings/settings_icon.dart';
import 'package:atloud/settings/vibration_setting.dart';
import 'package:atloud/settings/volume_setting.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../shared/user_data_storage.dart';
import 'footer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _backgroundSound = false;
  bool _screenLock = false;
  bool _vibration = false;
  bool _continueAfterAlarm = false;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Version $version'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<String> _appVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: 'USTAWIENIA'),
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
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SettingsIcon(constraints: constraints, incrementShowVersionCounter: _incrementShowVersionCounter),
                              VolumeSetting(data: data),
                              PeriodSetting(data: data),
                              BackgroundSoundSetting(data: data, backgroundSound: _backgroundSound, setState: setState),
                              ScreenLockSetting(data: data, screenLock: _screenLock, setState: setState),
                              AlarmTypeSetting(data: data, setState: setState),
                              VibrationSetting(data: data, vibration: _vibration, setState: setState),
                              ContinueAfterAlarmSetting(data: data, continueAfterAlarm: _continueAfterAlarm, setState: setState),
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
      bottomNavigationBar: const SettingsFooterWidget(),
    );
  }
}
