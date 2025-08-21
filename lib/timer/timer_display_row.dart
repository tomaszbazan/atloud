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

    // return Center(
    //   child: IntrinsicHeight(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: leftSide)),
    //         Text(":", style: textStyle),
    //         Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(secondsPart, style: textStyle)])),
    //         secondsPart.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.start, children: rightSide) : const SizedBox.shrink(),
    //       ],
    //     ),
    //   ),
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final parts = displayText.split(":");
  //   String hoursPart = parts[0];
  //   final minutesPart = parts[1];
  //   final secondsPart = parts.length > 2 ? parts[2] : "";
  //
  //   List<Widget> timeWidgets = [];
  //
  //   // Visibility for the negative sign (maintains size)
  //   timeWidgets.add(Visibility(
  //       visible: hoursPart.startsWith('-'),
  //       maintainSize: true,
  //       maintainAnimation: true,
  //       maintainState: true,
  //       child: Text("-", style: CustomTheme.clockTextTheme(context))));
  //
  //   // Strip the sign for numeric processing
  //   if (hoursPart.startsWith('-')) {
  //     hoursPart = hoursPart.substring(1);
  //   }
  //
  //   // Create the hour display widget (ensures two-digit width)
  //   Widget hourDisplayWidget;
  //   final textStyle = CustomTheme.clockTextTheme(context);
  //   if (hoursPart.length == 1) {
  //     hourDisplayWidget = Stack(
  //       children: <Widget>[
  //         // Invisible text to reserve width for two digits
  //         Text("00", style: textStyle.copyWith(color: Colors.transparent)),
  //         // Align the actual single digit to the end (e.g., right for LTR)
  //         Align(
  //           alignment: AlignmentDirectional.centerEnd,
  //           child: Text(hoursPart, style: textStyle),
  //         ),
  //       ],
  //     );
  //   } else {
  //     // hoursPart is already two digits
  //     hourDisplayWidget = Text(hoursPart, style: textStyle);
  //   }
  //   timeWidgets.add(hourDisplayWidget);
  //   timeWidgets.add(Text(":", style: CustomTheme.clockTextTheme(context)));
  //   timeWidgets.add(Text(minutesPart, style: CustomTheme.clockTextTheme(context)));
  //
  //   if (secondsPart.isNotEmpty) {
  //     timeWidgets.add(
  //       Padding(
  //         padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
  //         child: Text(
  //           ":$secondsPart",
  //           style: CustomTheme.smallClockTextTheme,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: timeWidgets,
  //   );
  // }
}
