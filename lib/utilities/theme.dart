import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(color: CompanyColors.color),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(color: CompanyColors.color),
  );
}

class CompanyColors {
  CompanyColors._();

  static const primaryColor = 0xFF1B344C;
  static const accentColor = 0xFF0AE20A;
  static const lightTextColor = 0xFF9c9ca0;
  static const infoBackgroundColor = 0xFFf2f2f7;
  static const chartWholeColor = 0x0AE20A;
  static const chartTenthColor = 0x0E2435;

  static const MaterialColor color = MaterialColor(
    primaryColor,
    <int, Color>{
      50: Color(primaryColor),
      100: Color(primaryColor),
      200: Color(primaryColor),
      300: Color(primaryColor),
      400: Color(primaryColor),
      500: Color(primaryColor),
      600: Color(primaryColor),
      700: Color(primaryColor),
      800: Color(primaryColor),
      900: Color(primaryColor),
    },
  );
}
