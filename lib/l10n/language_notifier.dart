import 'package:atloud/l10n/supported_language.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:flutter/material.dart';

class LanguageNotifier extends ChangeNotifier {
  static final LanguageNotifier _instance = LanguageNotifier._internal();
  factory LanguageNotifier() => _instance;
  LanguageNotifier._internal();

  Locale _locale = SupportedLanguage.values.first.locale;
  Locale get locale => _locale;

  Future<void> loadLocale() async {
    String languageCode = await UserDataStorage.languageValue();
    SupportedLanguage language = SupportedLanguage.fromCode(languageCode);
    _locale = language.locale;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    UserDataStorage.storeLanguageValue(languageCode);
    SupportedLanguage language = SupportedLanguage.fromCode(languageCode);
    _locale = language.locale;
    notifyListeners();
  }
}