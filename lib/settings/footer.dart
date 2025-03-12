import 'package:flutter/material.dart';

import '../theme/theme.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: TextButton(
            onPressed: () => _goToTimer(context),
            child: Text(
              'MINUTNIK',
              textAlign: TextAlign.center,
              style: CustomTheme.navigationTextTheme,
            ),
          ),
        ),
        FittedBox(
          child: TextButton(
            onPressed: () => _goToClock(context),
            child: Text(
              'ZEGAR',
              textAlign: TextAlign.center,
              style: CustomTheme.navigationTextTheme,
            ),
          ),
        ),
      ],
    );
  }
}
