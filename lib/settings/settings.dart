import 'package:atloud/components/app_bar.dart';
import 'package:atloud/settings/footer.dart';
import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:volume_controller/volume_controller.dart';

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

  // final FlutterTts _flutterTts = FlutterTts();
  // Future<dynamic> _getLanguages() async => await _flutterTts.getLanguages;
  // String? language;

  Future<SettingsData> _loadPreferences() async {
    return UserDataStorage.settings();
  }

  // Widget _languageBuilder() => FutureBuilder<dynamic>(
  //     future: _getLanguages(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       if (snapshot.hasData) {
  //         return _languageDropDownSection(snapshot.data as List<dynamic>);
  //       } else if (snapshot.hasError) {
  //         return const Text('Error loading languages...');
  //       } else {
  //         return const Text('Loading Languages...');
  //       }
  //     });
  //
  // Widget _languageDropDownSection(List<dynamic> languages) =>
  //       DropdownButton(
  //         icon: const SizedBox.shrink(),
  //         dropdownColor: Colors.white,
  //         alignment: AlignmentDirectional.center,
  //         style: CustomTheme.settingsTextTheme,
  //         underline: const SizedBox(),
  //         value: language,
  //         items: getLanguageDropDownMenuItems(languages),
  //         onChanged: changedLanguageDropDownItem,
  //       );
  //
  // void changedLanguageDropDownItem(String? selectedType) {
  //   setState(() {
  //     language = selectedType;
  //     _flutterTts.setLanguage(language!);
  //   });
  // }
  //
  // List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(List<dynamic> languages) {
  //   var items = <DropdownMenuItem<String>>[];
  //   for (dynamic type in languages) {
  //     items.add(DropdownMenuItem(
  //         value: type as String?, child: Text((type as String))));
  //   }
  //   return items;
  // }

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
    const double iconSize = 40.0;

    return Scaffold(
      appBar: const AppBarWidget(text: 'USTAWIENIA'),
      body: FutureBuilder<SettingsData>(
        future: _loadPreferences(),
        builder: (BuildContext context, AsyncSnapshot<SettingsData> snapshot) {
          if (snapshot.hasData) {
            SettingsData data = snapshot.requireData;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 50.0),
                      child: IconButton(icon: const Icon(Icons.settings, size: 70.0, color: CustomColors.textColor), onPressed: () => _incrementShowVersionCounter())),
                  Row(children: [
                    const Icon(Icons.volume_up, size: iconSize, color: CustomColors.textColor),
                    Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Głośność', style: CustomTheme.settingsTextTheme)),
                  ]),
                  Row(children: [
                    const SizedBox(width: 27.0),
                    Expanded(
                      child: Slider(
                        activeColor: CustomColors.textColor,
                        inactiveColor: CustomColors.textColor,
                        value: data.volumeValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: data.volumeValue.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            VolumeController().setVolume(value / 100, showSystemUI: true);
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 40, child: Text(data.volumeValue.round().toString(), textAlign: TextAlign.end, style: CustomTheme.settingsTextTheme)),
                  ]),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: iconSize, color: CustomColors.textColor),
                      Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Co ile minut', style: CustomTheme.settingsTextTheme))
                    ],
                  ),
                  Row(children: [
                    const SizedBox(width: 27.0),
                    Expanded(
                      child: Slider(
                        activeColor: CustomColors.textColor,
                        inactiveColor: CustomColors.textColor,
                        value: data.periodValue.toDouble(),
                        min: 1,
                        max: 60,
                        divisions: 59,
                        label: data.periodValue.toString(),
                        onChanged: (value) {
                          setState(() {
                            UserDataStorage.storePeriodValue(value.toInt());
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 40.0, child: Text(data.periodValue.toString(), textAlign: TextAlign.end, style: CustomTheme.settingsTextTheme)),
                  ]),
                  Row(
                    children: [
                      const SizedBox(width: iconSize, height: iconSize),
                      Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Odtwarzaj dźwięk w tle', style: CustomTheme.settingsTextTheme))),
                      Switch(
                          value: data.backgroundSoundValue,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          activeColor: Colors.white,
                          onChanged: (_) => setState(() {
                                _backgroundSound = !_backgroundSound;
                                UserDataStorage.storeBackgroundSoundValue(_backgroundSound);
                              }))
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: iconSize, height: iconSize),
                      Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Wyłącz automatyczną blokadę ekranu', style: CustomTheme.settingsTextTheme))),
                      Switch(
                          value: data.screenLockValue,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          activeColor: Colors.white,
                          onChanged: (_) => setState(() {
                                _screenLock = !_screenLock;
                                UserDataStorage.storeScreenLockValue(_screenLock);
                              }))
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: iconSize, height: iconSize),
                      Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Dźwięk alarmu', style: CustomTheme.settingsTextTheme))),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: DropdownButton<String>(
                            icon: const SizedBox.shrink(),
                            dropdownColor: Colors.white,
                            alignment: AlignmentDirectional.center,
                            style: CustomTheme.settingsTextTheme,
                            underline: const SizedBox(),
                            value: data.alarmTypeValue.displayName,
                            items: AlarmType.values.map((e) => DropdownMenuItem(value: e.displayName, child: Text(e.displayName))).toList(),
                            onChanged: (value) {
                              setState(() {
                                UserDataStorage.storeAlarmTypeValue(value!);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     const SizedBox(width: iconSize, height: iconSize),
                  //     Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Język mówienia', style: CustomTheme.settingsTextTheme))),
                  //     Container(
                  //       width: 140,
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //       child: Center(
                  //         child: _languageBuilder(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      const SizedBox(width: iconSize, height: iconSize),
                      Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Wibracja', style: CustomTheme.settingsTextTheme))),
                      Switch(
                          value: data.vibrationValue,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          activeColor: Colors.white,
                          onChanged: (_) => setState(() {
                                _vibration = !_vibration;
                                UserDataStorage.storeVibrationValue(_vibration);
                              }))
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: iconSize, height: iconSize),
                      Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text('Kontynuuj odliczanie minutnika po czasie', style: CustomTheme.settingsTextTheme))),
                      Switch(
                          value: data.continuationAfterAlarmValue,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          activeColor: Colors.white,
                          onChanged: (_) => setState(() {
                                _continueAfterAlarm = !_continueAfterAlarm;
                                UserDataStorage.storeContinueAfterAlarmValue(_continueAfterAlarm);
                              }))
                    ],
                  ),
                  const SettingsFooterWidget()
                ],
              ),
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
    );
  }
}
