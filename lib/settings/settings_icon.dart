import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

class SettingsIcon extends StatelessWidget {
  const SettingsIcon({
    super.key,
    required this.constraints,
    required this.incrementShowVersionCounter,
  });

  final BoxConstraints constraints;
  final Function() incrementShowVersionCounter;

  @override
  Widget build(BuildContext context) {
    return constraints.maxHeight > 600
        ? Container(
            margin: const EdgeInsets.only(bottom: 20.0), child: IconButton(icon: const Icon(Icons.settings, size: 70.0, color: CustomColors.textColor), onPressed: () => incrementShowVersionCounter()))
        : const SizedBox.shrink();
  }
}
