import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class PeriodSetting extends StatelessWidget {
  const PeriodSetting({
    super.key,
    required this.data,
  });

  final SettingsData data;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Column(
      children: [
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
                UserDataStorage.storePeriodValue(value.toInt());
              },
            ),
          ),
          SizedBox(width: 40.0, child: Text(data.periodValue.toString(), textAlign: TextAlign.end, style: CustomTheme.settingsTextTheme)),
        ]),
      ],
    );
  }
}
