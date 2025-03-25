import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class ContinueAfterAlarmSetting extends StatelessWidget {
  const ContinueAfterAlarmSetting({
    super.key,
    required this.data,
    required this.continueAfterAlarm,
    required this.setState,
  });

  final SettingsData data;
  final bool continueAfterAlarm;
  final StateSetter setState;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Row(
      children: [
        const SizedBox(width: iconSize, height: iconSize),
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text('Kontynuuj odliczanie minutnika po czasie', style: CustomTheme.settingsTextTheme))),
        Switch(
            value: data.continuationAfterAlarmValue,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (_) => setState(() {
                  //_continueAfterAlarm = !_continueAfterAlarm;
                  UserDataStorage.storeContinueAfterAlarmValue(!data.continuationAfterAlarmValue);
                }))
      ],
    );
  }
}
