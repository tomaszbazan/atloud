import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeSetting extends StatefulWidget {
  const VolumeSetting({
    super.key,
    required this.data,
  });

  final SettingsData data;

  @override
  State<VolumeSetting> createState() => _VolumeSettingState();
}

class _VolumeSettingState extends State<VolumeSetting> {
  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Column(
      children: [
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
              value: widget.data.volumeValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: widget.data.volumeValue.round().toString(),
              onChanged: (value) {
                setState(() {
                  VolumeController().setVolume(value / 100, showSystemUI: true);
                });
              },
            ),
          ),
          SizedBox(width: 40, child: Text(widget.data.volumeValue.round().toString(), textAlign: TextAlign.end, style: CustomTheme.settingsTextTheme)),
        ]),
      ],
    );
  }
}
