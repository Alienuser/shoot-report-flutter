import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = 0xFF1B344C;
  static const accentColor = 0xFF0AE20A;
  static const lightTextColor = 0xFF9c9ca0;
  static const infoBackgroundColor = 0xFFf2f2f7;
  static const chartWholeColor = 0x0AE20A;
  static const chartTenthColor = 0x0E2435;

  static final ThemeData lightTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(primaryColor),
      ),
      useMaterial3: true);

  static final ThemeData darkTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(primaryColor),
      ),
      useMaterial3: true);
}
