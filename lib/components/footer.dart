import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

import '../feedback/feedback_page.dart';
import '../shared/available_page.dart';
import '../theme/theme.dart';
import '../timer/timer.dart';

class FooterWidget extends StatelessWidget {
  final AvailablePage currentPage;
  final Function()? actionOnClick;
  final Function()? onClockTap;
  final Function()? onTimerTap;
  final iconWidth = 30.0;
  final iconHeight = 30.0;

  const FooterWidget({
    super.key,
    required this.currentPage,
    this.actionOnClick,
    this.onClockTap,
    this.onTimerTap,
  });

  Widget _buildNavItem(BuildContext context, {
    required Widget iconWidget,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isActive ? (isDark ? CustomColors.darkTimerRingColor : CustomColors.timerRingColor) : (isDark ? CustomColors.darkFooterBackgroundColor : CustomColors.footerBackgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: isDark ? CustomColors.darkFooterTextColor : CustomColors.footerTextColor, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: CustomTheme.navigationBarHeight(context),
      color: isDark ? CustomColors.darkFooterBackgroundColor : CustomColors.footerBackgroundColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/clock.png', width: iconWidth, height: iconHeight, color: isDark ? CustomColors.darkFooterTextColor : CustomColors.footerTextColor),
              label: localizations.clockTab,
              isActive: currentPage == AvailablePage.clock,
              onTap: () {
                if (onClockTap != null) {
                  onClockTap!();
                } else if (actionOnClick != null) {
                  actionOnClick!();
                } else {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const TimerPage(isTimerPage: false),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              }
            ),
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/timer.png', width: iconWidth, height: iconHeight, color: isDark ? CustomColors.darkFooterTextColor : CustomColors.footerTextColor),
              label: localizations.timerTab,
              isActive: currentPage == AvailablePage.timer,
              onTap: () {
                if (onTimerTap != null) {
                  onTimerTap!();
                } else if (actionOnClick != null) {
                  actionOnClick!();
                } else {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const TimerPage(isTimerPage: true),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              }
            ),
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/feedback.png', width: iconWidth, height: iconHeight, color: isDark ? CustomColors.darkFooterTextColor : CustomColors.footerTextColor),
              label: localizations.feedbackTab,
              isActive: currentPage == AvailablePage.feedback,
              onTap: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const FeedbackPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
            _buildNavItem(
              context,
              iconWidget: Icon(Icons.settings_outlined, size: iconWidth, color: isDark ? CustomColors.darkFooterTextColor : CustomColors.footerTextColor),
              label: localizations.settingsTab,
              isActive: currentPage == AvailablePage.settings,
                onTap: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const SettingsPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
