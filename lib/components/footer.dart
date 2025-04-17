import 'package:atloud/settings/settings.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final String text;
  final Function() actionOnText;

  const FooterWidget({super.key, required this.text, required this.actionOnText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: CustomColors.footerBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                ),
                onPressed: actionOnText,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: CustomTheme.bottomButtonTheme,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      size: 60,
                      color: CustomColors.footerTextColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
