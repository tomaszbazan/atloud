import 'package:atloud/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum SupportedLanguage {
  polish('pl', 'pl-PL', Locale('pl'), 'pl-PL-language'),
  english('en', 'en-US', Locale('en'), 'en-US-language');

  final String code;
  final String countryCode;
  final Locale locale;
  final String defaultVoice;

  const SupportedLanguage(this.code, this.countryCode, this.locale, this.defaultVoice);

  static const SupportedLanguage defaultLanguage = english;

  static SupportedLanguage fromCode(String code) {
    return values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => defaultLanguage,
    );
  }

  static List<Locale> get supportedLocales {
    return values.map((lang) => lang.locale).toList();
  }

  String getDisplayName(AppLocalizations localizations) {
    switch (this) {
      case SupportedLanguage.polish:
        return localizations.polish;
      case SupportedLanguage.english:
        return localizations.english;
    }
  }
}
