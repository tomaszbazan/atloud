import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class ScreenLockSetting extends StatelessWidget {
  const ScreenLockSetting({
    super.key,
    required this.data,
    required this.screenLock,
    required this.setState,
  });

  final SettingsData data;
  final bool screenLock;
  final StateSetter setState;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Row(
      children: [
        const SizedBox(width: iconSize, height: iconSize),
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text('Wyłącz automatyczną blokadę ekranu', style: CustomTheme.settingsTextTheme))),
        Switch(
            value: data.screenLockValue,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (_) => setState(() {
                  //_screenLock = !_screenLock;
                  UserDataStorage.storeScreenLockValue(!data.screenLockValue);
                }))
      ],
    );
  }
}
