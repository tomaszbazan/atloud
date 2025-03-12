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
        timePickerTheme: TimePickerThemeData(
          dialBackgroundColor: CustomColors.lightBackgroundColor,
          hourMinuteColor: CustomColors.lightBackgroundColor,
          hourMinuteTextColor: CustomColors.textColor,
          dialTextColor: CustomColors.textColor,
          dialHandColor: Colors.white,
          cancelButtonStyle: ButtonStyle(
              textStyle: WidgetStatePropertyAll(TextStyle(
            fontSize: 20,
            color: CustomColors.textColor,
            fontFamily: CustomFonts.openSans.value,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ))),
          confirmButtonStyle: ButtonStyle(
              textStyle: WidgetStatePropertyAll(TextStyle(
            fontSize: 20,
            color: CustomColors.textColor,
            fontFamily: CustomFonts.openSans.value,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ))),
          helpTextStyle: const TextStyle(
            fontSize: 0,
          ),
        ));
  }

  static TextStyle bottomButtonTheme = TextStyle(
    fontSize: 25,
    color: CustomColors.textColor,
    fontFamily: CustomFonts.openSans.value,
    fontWeight: FontWeight.bold,
    letterSpacing: 4.0,
  );

  static TextStyle settingsTextTheme = TextStyle(fontSize: 20, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, letterSpacing: 1.0);
  static TextStyle navigationTextTheme = TextStyle(fontSize: 25, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, fontWeight: FontWeight.bold, letterSpacing: 4.0);
}
