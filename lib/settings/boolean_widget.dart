import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class BooleanWidget extends StatefulWidget {
  const BooleanWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
  });

  final bool value;
  final String label;
  final Function(bool) onChange;

  @override
  State<BooleanWidget> createState() => _BooleanWidgetState();
}

class _BooleanWidgetState extends State<BooleanWidget> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(margin: CustomTheme.settingsItemsMarginTheme, child: Text(widget.label, style: CustomTheme.settingsTextTheme(context)))),
        Switch(
            value: _currentValue,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (_) => setState(() {
                  _currentValue = !_currentValue;
                  widget.onChange(_currentValue);
                }))
      ],
    );
  }
}
