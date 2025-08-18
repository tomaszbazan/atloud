import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/sound/alarm_type.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class AlarmTypeSetting extends StatefulWidget {
  const AlarmTypeSetting({
    super.key,
    required this.data,
    required this.setState,
  });

  final SettingsData data;
  final StateSetter setState;

  @override
  State<AlarmTypeSetting> createState() => _AlarmTypeSettingState();
}

class _AlarmTypeSettingState extends State<AlarmTypeSetting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text(AppLocalizations.of(context)!.alarmSettings, style: CustomTheme.settingsTextTheme))),
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
              value: widget.data.alarmTypeValue.name,
              items: AlarmType.values.map((e) => DropdownMenuItem(value: e.name, child: Text(e.getDisplayName(AppLocalizations.of(context)!)))).toList(),
              onChanged: (value) {
                widget.setState(() {
                  UserDataStorage.storeAlarmTypeValue(value!);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
