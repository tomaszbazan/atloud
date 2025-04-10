import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class BackgroundSoundSetting extends StatelessWidget {
  const BackgroundSoundSetting({
    super.key,
    required this.data,
    required this.backgroundSound,
    required this.setState,
  });

  final SettingsData data;
  final bool backgroundSound;
  final StateSetter setState;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Row(
      children: [
        const SizedBox(width: iconSize, height: iconSize),
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text('Odtwarzaj dźwięk w tle', style: CustomTheme.settingsTextTheme))),
        Switch(
            value: data.backgroundSoundValue,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (_) => setState(() {
                  //_backgroundSound = !_backgroundSound;
                  UserDataStorage.storeBackgroundSoundValue(!data.backgroundSoundValue);
                }))
      ],
    );
  }
}
