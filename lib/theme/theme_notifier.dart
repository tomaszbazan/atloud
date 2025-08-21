import 'package:atloud/shared/user_data_storage.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  static final ThemeNotifier _instance = ThemeNotifier._internal();
  factory ThemeNotifier() => _instance;
  ThemeNotifier._internal();

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadTheme() async {
    _isDarkTheme = await UserDataStorage.isDarkTheme();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    UserDataStorage.storeIsDarkTheme(_isDarkTheme);
    notifyListeners();
  }

  void setTheme(bool isDark) {
    if (_isDarkTheme != isDark) {
      _isDarkTheme = isDark;
      UserDataStorage.storeIsDarkTheme(_isDarkTheme);
      notifyListeners();
    }
  }
}