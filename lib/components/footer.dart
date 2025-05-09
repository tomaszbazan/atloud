import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

import '../shared/available_page.dart';
import '../timer/timer.dart';

class FooterWidget extends StatelessWidget {
  final AvailablePage currentPage;
  final Function()? actionOnClick;

  const FooterWidget({
    super.key,
    required this.currentPage,
    this.actionOnClick,
  });

  Widget _buildNavItem(BuildContext context, {
    required IconData icon,
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
              Icon(icon, size: 30, color: CustomColors.footerTextColor),
              const SizedBox(height: 4),
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
      height: 80,
      color: CustomColors.footerBackgroundColor,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.watch_later_outlined,
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
              icon: Icons.timer_outlined,
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
              icon: Icons.settings_outlined,
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
