import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(CustomTheme.onBoardingSpacing(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: CustomTheme.onBoardingSpacing(context)),
          Image.asset(
            'assets/onboarding/logo.png',
            height: CustomTheme.onBoardingLogoHeight(context),
          ),
          SizedBox(height: CustomTheme.onBoardingSpacing(context) * 2),
          Text(
            localizations.onboardingTitle1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme.onBoardingTextBig(context),
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          SizedBox(height: CustomTheme.onBoardingSpacing(context) * 1.5),
          Text(
            localizations.onboardingWelcome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme.onBoardingTextSmall(context),
              fontFamily: CustomFonts.openSans.value,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          SizedBox(height: CustomTheme.onBoardingSpacing(context) * 1.5),
          Text(
            localizations.onboardingHappy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme.onBoardingTextSmall(context),
              fontFamily: CustomFonts.openSans.value,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          SizedBox(height: CustomTheme.onBoardingSpacing(context) * 1.5),
          Text(
            localizations.onboardingTips,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme.onBoardingTextSmall(context),
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
