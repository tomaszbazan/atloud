import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '👉 ${localizations.onboardingMuteClock}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: CustomFonts.openSans.value,
                    fontWeight: FontWeight.bold,
                    color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            localizations.onboardingMuteUseful,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontFamily: CustomFonts.openSans.value,
              fontStyle: FontStyle.italic,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/onboarding/page2_screenshot.png',
            height: 450,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
