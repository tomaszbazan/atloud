import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TimeDisplayRow extends StatefulWidget {
  final String displayText;

  const TimeDisplayRow({
    super.key,
    required this.displayText,
  });

  @override
  State<TimeDisplayRow> createState() => _TimeDisplayRowState();
}

class _TimeDisplayRowState extends State<TimeDisplayRow> {
  final GlobalKey _rowKey = GlobalKey();
  double _rowWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateRowSize());
  }

  void _updateRowSize() {
    final RenderBox? renderBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _rowWidth = renderBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.displayText.split(":");
    final hours = parts[0];
    final minutes = parts[1];
    final seconds = parts.length > 2 ? parts[2] : "";

    return LayoutBuilder(
      builder: (context, constraints) {
        print('rowWidth $_rowWidth');
        print('maxWidth ${constraints.maxWidth}');
        return Stack(
          alignment: Alignment.center,
          children: [
            Row(
              key: _rowKey,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hours,
                  style: CustomTheme.clockTextTheme(context),
                  textAlign: TextAlign.right,
                ),
                Text(":", style: CustomTheme.clockTextTheme(context)),
                Text(
                  minutes,
                  style: CustomTheme.clockTextTheme(context),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            if (seconds.isNotEmpty)
              Positioned(
                bottom: 10.0,
                left: (constraints.maxWidth / 2) + (_rowWidth / 2) + 10,
                child: Text(
                  ":$seconds",
                  style: CustomTheme.smallClockTextTheme,
                ),
              ),
          ],
        );
      }
    );
  }
}