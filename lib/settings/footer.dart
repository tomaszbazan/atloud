import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
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
    return Container(
      color: CustomColors.footerBackgroundColor,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                ),
                onPressed: () => _goToTimer(context),
                child: Text(
                  'MINUTNIK',
                  textAlign: TextAlign.center,
                  style: CustomTheme.bottomButtonTheme,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.white30,
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () => _goToClock(context),
                child: Text(
                  'ZEGAR',
                  textAlign: TextAlign.center,
                  style: CustomTheme.bottomButtonTheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
