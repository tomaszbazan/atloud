import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

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
          Image.asset(
            'assets/onboarding/logo.png',
            height: 120,
          ),
          const SizedBox(height: 60),
          Text(
            localizations.onboardingTitle1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            localizations.onboardingWelcome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontFamily: CustomFonts.openSans.value,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            localizations.onboardingHappy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontFamily: CustomFonts.openSans.value,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            localizations.onboardingTips,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
