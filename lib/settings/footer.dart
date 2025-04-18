import 'package:flutter/material.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';

import '../timer/timer.dart';

class SettingsFooterWidget extends StatelessWidget {
  const SettingsFooterWidget({super.key});

  void _goToTimer(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TimerPage(isTimerPage: true)));
  }

  void _goToClock(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TimerPage(isTimerPage: false)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
              width: 3,
              height: 30,
              color: CustomColors.footerTextColor,
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
