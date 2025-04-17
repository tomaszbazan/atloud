import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChange
  });

  final IconData icon;
  final String label;
  final int min;
  final int max;
  final int value;
  final Function(int) onChange;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Column(
      children: [
        Row(children: [
          Icon(widget.icon, size: iconSize, color: CustomColors.textColor),
          Container(margin: const EdgeInsets.symmetric(horizontal: 10.0), child: Text(widget.label, style: CustomTheme.settingsTextTheme)),
        ]),
        Row(children: [
          const SizedBox(width: 27.0),
          Expanded(
            child: Slider(
                activeColor: CustomColors.textColor,
                inactiveColor: CustomColors.textColor,
                value: _currentValue.toDouble(),
                min: widget.min.toDouble(),
                max: widget.max.toDouble(),
                divisions: widget.max - widget.min,
                label: _currentValue.toString(),
                onChanged: (value) => setState(() {
                  _currentValue = value.toInt();
                  widget.onChange(value.toInt());
                })),
          ),
          SizedBox(width: 40.0, child: Text(_currentValue.toString(), textAlign: TextAlign.end, style: CustomTheme.settingsTextTheme)),
        ]),
      ],
    );
  }
}
