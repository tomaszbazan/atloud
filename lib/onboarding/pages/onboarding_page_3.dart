import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '👉 ${localizations.onboardingSetTimer}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: CustomTheme.onBoardingTextBig(context) * 0.9,
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
            localizations.onboardingSetTime,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme.onBoardingTextSmall(context) * 0.9,
              fontFamily: CustomFonts.openSans.value,
              fontStyle: FontStyle.italic,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/onboarding/page3_screenshot.png',
            height: CustomTheme.onBoardingImageHeight(context),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
