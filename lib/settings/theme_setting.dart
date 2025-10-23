import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/theme/theme_notifier.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Row(
          children: [
            Expanded(
              child: Container(
                margin: CustomTheme.settingsItemsMarginTheme,
                child: Text(
                  localizations.darkMode,
                  style: CustomTheme.settingsTextTheme(context),
                ),
              ),
            ),
            Switch(
              value: ThemeNotifier().isDarkTheme,
              activeTrackColor: Colors.black,
              inactiveTrackColor: Colors.black,
              activeThumbColor: Colors.white,
              onChanged: (value) => ThemeNotifier().setTheme(value),
            ),
          ],
        );
      },
    );
  }
}