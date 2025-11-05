import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

class OnboardingPage4 extends StatelessWidget {
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '👉 ${localizations.onboardingPermissions}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: CustomFonts.openSans.value,
                    fontWeight: FontWeight.bold,
                    color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            localizations.onboardingAccept,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            localizations.onboardingEnjoy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
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
