import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../theme/colors.dart';

class TimePickerWidget extends StatefulWidget {
  final Duration initialTime;
  final Function(Duration) onTimeSelected;

  const TimePickerWidget({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final now = TimeOfDay.now();
  late final _hoursWheel = WheelPickerController(
    itemCount: 24,
    initialIndex: widget.initialTime.inHours.remainder(24),
  );
  late final _minutesWheel = WheelPickerController(
    itemCount: 60,
    initialIndex: widget.initialTime.inMinutes.remainder(60),
    mounts: [_hoursWheel],
  );

  void _confirmTimeSelection() {
    final newTime = Duration(hours: _hoursWheel.selected, minutes: _minutesWheel.selected);
    widget.onTimeSelected(newTime);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = CustomTheme.clockTextTheme(context);
    final wheelStyle = WheelPickerStyle(itemExtent: textStyle.fontSize! * textStyle.height!, diameterRatio: 1.5, squeeze: 0.8, surroundingOpacity: .50, magnification: 1.0);

    Widget itemBuilder(BuildContext context, int index) {
      return Expanded(child: Text("$index".padLeft(2, '0'), style: textStyle, textAlign: TextAlign.right));
    }

    final timeWheels = <Widget>[
      for (final wheelController in [_hoursWheel, _minutesWheel])
        Expanded(
          child: WheelPicker(
            builder: itemBuilder,
            controller: wheelController,
            looping: wheelController == _minutesWheel,
            style: wheelStyle,
            selectedIndexColor: CustomColors.textColor,
          ),
        ),
    ];
    timeWheels.insert(1, Text(":", style: textStyle));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30.0),
          child: SizedBox(
            height: 300,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ...timeWheels
                    Expanded(
                      child: WheelPicker(
                            builder: (context, index) => Row(
                              children: [
                                Expanded(child: Text("$index".padLeft(2, '0'), style: textStyle, textAlign: TextAlign.right)),
                              ],
                            ),
                        controller: _hoursWheel,
                        looping: true,
                        style: wheelStyle,
                        selectedIndexColor: CustomColors.textColor,
                      ),
                    ),
                    Text(":", style: textStyle),
                    Expanded(
                      child: WheelPicker(
                        builder: (context, index) => Row(
                          children: [
                                Expanded(child: Text("$index".padLeft(2, '0'), style: textStyle, textAlign: TextAlign.left)),
                              ],
                            ),
                        controller: _minutesWheel,
                        looping: true,
                        style: wheelStyle,
                        selectedIndexColor: CustomColors.textColor,
                      ),
                    ),
                  ],
                ),
                _centerBar(context),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: _confirmTimeSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.footerBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Text("START", style: CustomTheme.bottomButtonTheme),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hoursWheel.dispose();
    _minutesWheel.dispose();
    super.dispose();
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 110.0,
          decoration: BoxDecoration(
            color: CustomColors.textColor.withAlpha(80),
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
      ),
    );
  }
}
