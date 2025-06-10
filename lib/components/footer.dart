import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

// Import FeedbackPage instead of FeedbackLauncher
import '../feedback/feedback_page.dart'; 
import '../shared/available_page.dart';
import '../theme/theme.dart';
import '../timer/timer.dart';

class FooterWidget extends StatelessWidget {
  final AvailablePage currentPage;
  final Function()? actionOnClick;
  final iconWidth = 30.0;
  final iconHeight = 30.0;

  const FooterWidget({
    super.key,
    required this.currentPage,
    this.actionOnClick,
  });

  Widget _buildNavItem(BuildContext context, {
    required Widget iconWidget,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isActive ? CustomColors.secondColor : CustomColors.footerBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: CustomColors.footerTextColor, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CustomTheme.navigationBarHeight(context),
      color: CustomColors.footerBackgroundColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/clock.png', width: iconWidth, height: iconHeight, color: CustomColors.footerTextColor),
              label: 'ZEGAR',
              isActive: currentPage == AvailablePage.clock,
              onTap: () => actionOnClick != null ? actionOnClick!() : Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const TimerPage(isTimerPage: false),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              )
            ),
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/timer.png', width: iconWidth, height: iconHeight, color: CustomColors.footerTextColor),
              label: 'MINUTNIK',
              isActive: currentPage == AvailablePage.timer,
                onTap: () => actionOnClick != null ? actionOnClick!() : Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const TimerPage(isTimerPage: true),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                )
            ),
            _buildNavItem(
              context,
              iconWidget: Image.asset('assets/icons/feedback.png', width: iconWidth, height: iconHeight, color: CustomColors.footerTextColor),
              label: 'OPINIA',
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
              iconWidget: Icon(Icons.settings_outlined, size: iconWidth, color: CustomColors.footerTextColor),
              label: 'USTAWIENIA',
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
