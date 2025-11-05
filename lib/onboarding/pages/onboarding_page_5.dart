import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingPage5 extends StatefulWidget {
  const OnboardingPage5({super.key});

  @override
  State<OnboardingPage5> createState() => _OnboardingPage5State();
}

class _OnboardingPage5State extends State<OnboardingPage5> with WidgetsBindingObserver {
  bool _notificationsGranted = false;
  bool _batteryOptimizationDisabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final batteryOptimizationDisabled = await FlutterForegroundTask.isIgnoringBatteryOptimizations;

    setState(() {
      _notificationsGranted = notificationStatus.isGranted;
      _batteryOptimizationDisabled = batteryOptimizationDisabled;
    });
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      final newStatus = await Permission.notification.request();
      setState(() {
        _notificationsGranted = newStatus.isGranted;
      });
    }
  }

  Future<void> _requestBatteryOptimization() async {
    await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            localizations.permissionsTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontFamily: CustomFonts.openSans.value,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
            ),
          ),
          const Spacer(),
          _buildPermissionItem(
            context: context,
            title: localizations.permissionNotifications,
            isGranted: _notificationsGranted,
            onTap: _requestNotificationPermission,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          _buildPermissionItem(
            context: context,
            title: localizations.permissionBattery,
            isGranted: _batteryOptimizationDisabled,
            onTap: _requestBatteryOptimization,
            isDark: isDark,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPermissionItem({
    required BuildContext context,
    required String title,
    required bool isGranted,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? CustomColors.darkSecondColor : CustomColors.secondColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.cancel,
            color: isGranted ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: CustomFonts.openSans.value,
                    fontWeight: FontWeight.bold,
                    color: isDark ? CustomColors.darkTextColor : CustomColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isGranted ? localizations.permissionGranted : localizations.permissionNotGranted,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.openSans.value,
                    color: (isDark ? CustomColors.darkTextColor : CustomColors.textColor).withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: isGranted ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? CustomColors.darkSecondColor : CustomColors.secondColor,
              disabledBackgroundColor: (isDark ? CustomColors.darkSecondColor : CustomColors.secondColor).withAlpha(128),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              localizations.permissionGrant,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: CustomFonts.openSans.value,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
