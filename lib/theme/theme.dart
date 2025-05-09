import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: CustomColors.lightBackgroundColor,
      appBarTheme: AppBarTheme(
          titleSpacing: 20,
          backgroundColor: CustomColors.lightBackgroundColor,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 25, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, fontWeight: FontWeight.bold, letterSpacing: 4.0)),
      textButtonTheme: const TextButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(CustomColors.textColor))),
    );
  }

  static TextStyle bottomButtonTheme = TextStyle(
    fontSize: 22,
    color: CustomColors.footerTextColor,
    fontFamily: CustomFonts.openSans.value,
    fontWeight: FontWeight.bold,
    letterSpacing: 6.0,
  );
  static TextStyle settingsTextTheme = TextStyle(fontSize: 20, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, letterSpacing: 1.0, height: 0.95);
  static EdgeInsetsGeometry settingsItemsMarginTheme = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0);
  static TextStyle navigationTextTheme = TextStyle(fontSize: 25, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, fontWeight: FontWeight.bold, letterSpacing: 4.0);
  static TextStyle clockTextTheme = TextStyle(fontSize: 110, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value, height: 1.0);
}
