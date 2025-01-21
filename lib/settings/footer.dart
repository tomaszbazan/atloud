import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

import '../clock/clock.dart';
import '../theme/fonts.dart';
import '../timer/timer.dart';

class SettingsFooterWidget extends StatelessWidget {
  const SettingsFooterWidget({super.key});

  void _goToTimer(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TimerPage()));
  }

  void _goToClock(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ClockPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => _goToTimer(context),
          child: Text(
            'MINUTNIK',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: CustomColors.textColor,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _goToClock(context),
          child: Text(
            'ZEGAR',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: CustomColors.textColor,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0,
            ),
          ),
        ),
      ],
    );
  }
}
