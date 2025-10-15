import 'package:flutter/material.dart';

import '../theme/theme.dart';

class TimeDisplayRow extends StatelessWidget {
  final String displayText;

  const TimeDisplayRow({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    final textStyle = CustomTheme.clockTextTheme(context);
    final parts = displayText.split(":");
    String hoursPart = parts[0];
    final minutesPart = parts[1];
    final secondsPart = parts.length > 2 ? parts[2] : "";
    final showMinus = hoursPart.startsWith('-');
    if (showMinus) {
      hoursPart = hoursPart.substring(1);
    }

    var leftSide = List<Widget>.empty(growable: true);
    if (showMinus) {
      leftSide.add(Text("-", style: textStyle));
    }
    leftSide.add(Text(hoursPart, style: textStyle));

    var rightSide = List<Widget>.empty(growable: true);

    rightSide.add(Padding(
      padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
      child: Text(
        ":$secondsPart",
        style: CustomTheme.smallClockTextTheme(context),
      ),
    ));

    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showMinus)
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Text(
                          "-",
                          style: textStyle,
                        ),
                      ),
                    Text(
                      hoursPart,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
              Text(
                ":",
                style: textStyle,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      minutesPart,
                      style: textStyle,
                    ),
                    secondsPart.isNotEmpty ? Padding(
                        padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
                        child: Text(
                          ":$secondsPart",
                          style: CustomTheme.smallClockTextTheme(context),
                        )
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
