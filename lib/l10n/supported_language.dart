import 'package:atloud/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum SupportedLanguage {
  polish('pl', Locale('pl')),
  english('en', Locale('en'));

  final String code;
  final Locale locale;

  const SupportedLanguage(this.code, this.locale);

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