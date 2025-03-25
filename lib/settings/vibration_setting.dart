import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class VibrationSetting extends StatelessWidget {
  const VibrationSetting({
    super.key,
    required this.data,
    required this.vibration,
    required this.setState,
  });

  final SettingsData data;
  final bool vibration;
  final StateSetter setState;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Row(
      children: [
        const SizedBox(width: iconSize, height: iconSize),
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text('Wibracja', style: CustomTheme.settingsTextTheme))),
        Switch(
            value: data.vibrationValue,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (_) => setState(() {
                  //_vibration = !_vibration;
                  UserDataStorage.storeVibrationValue(!data.vibrationValue);
                }))
      ],
    );
  }
}
