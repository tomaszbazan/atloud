import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/l10n/language_notifier.dart';
import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/settings/settings_data.dart';
import 'package:atloud/theme/theme.dart';
import 'package:flutter/material.dart';

class LanguageSetting extends StatefulWidget {
  final SettingsData data;
  final StateSetter setState;

  const LanguageSetting({
    super.key,
    required this.data,
    required this.setState,
  });

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: CustomTheme.settingsItemsMarginTheme,
            child: Text(
              localizations.language,
              style: CustomTheme.settingsTextTheme,
            ),
          ),
        ),
        Container(
          width: 140,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: DropdownButton<String>(
              icon: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              alignment: AlignmentDirectional.center,
              style: CustomTheme.settingsTextTheme,
              underline: const SizedBox(),
              value: widget.data.languageValue.code,
              items:
                  SupportedLanguage.values.map((language) {
                    return DropdownMenuItem(
                      value: language.code,
                      child: Text(
                        language.getDisplayName(localizations).toUpperCase(),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                widget.setState(() {
                  LanguageNotifier().changeLanguage(value!);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
