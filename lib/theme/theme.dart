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
  static TextStyle primaryButtonTextTheme = TextStyle(
    fontSize: 22,
    color: CustomColors.footerTextColor,
    fontFamily: CustomFonts.openSans.value,
    fontWeight: FontWeight.bold,
    letterSpacing: 6.0);
  static TextStyle settingsTextTheme = TextStyle(fontSize: 20,
      color: CustomColors.textColor,
      fontFamily: CustomFonts.openSans.value,
      letterSpacing: 1.0,
      height: 0.95);
  static EdgeInsetsGeometry settingsItemsMarginTheme = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0);
  static TextStyle navigationTextTheme = TextStyle(fontSize: 25, color: CustomColors.textColor, fontFamily: CustomFonts.openSans.value, fontWeight: FontWeight.bold, letterSpacing: 4.0);

  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: CustomColors.footerBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  static TextStyle clockTextTheme(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(fontSize: _getAdaptiveWidth(screenWidth, 65, 100), color: CustomColors.textColor, fontFamily: CustomFonts.abril.value, height: 1.0);
  }

  static double navigationBarHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return _getAdaptiveHeight(screenHeight, 80, 110);
  }

  static TextStyle smallClockTextTheme = TextStyle(fontSize: 25, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value, height: 1.0);

  static double _getAdaptiveHeight(double screenHeight, double minElementSize, double maxElementSize) {
    const double smallestScreenHeight = 640.0;
    const double largestScreenHeight = 960.0;

    return _calculateSize(screenHeight, smallestScreenHeight, largestScreenHeight, minElementSize, maxElementSize);
  }
  
  static double _getAdaptiveWidth(double screenWidth, double minElementSize, double maxElementSize) {
    const double smallestScreenWidth = 360.0;
    const double largestScreenWidth = 480.0;

    return _calculateSize(screenWidth, smallestScreenWidth, largestScreenWidth, minElementSize, maxElementSize);
  }

  static double _calculateSize(double currentScreenSize, double smallestScreenSize, double largestScreenSize, double minElementSize, double maxElementSize) {
    if (currentScreenSize <= smallestScreenSize) {
      return minElementSize;
    } else if (currentScreenSize >= largestScreenSize) {
      return maxElementSize;
    } else {
      final double ratio = (currentScreenSize - smallestScreenSize) / (largestScreenSize - smallestScreenSize);
      return minElementSize + (maxElementSize - minElementSize) * ratio;
    }
  }
}