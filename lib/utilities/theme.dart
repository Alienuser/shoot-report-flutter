import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = 0xFF1B344C;
  static const accentColor = 0xFF0AE20A;
  static const backgroundColorLight = 0xFFF2F2F7;
  static const backgroundColorDark = 0xFF2c2c2e;
  static const backgroundAdsLight = 0xFFFDFCFF;
  static const backgroundAdsDark = 0xFF1A1C1E;
  static const lightTextColor = 0xFF9c9ca0;
  static const chartWholeColor = 0x0AE20A;
  static const chartTenthColor = 0x0E2435;

  static final ThemeData lightTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(backgroundColorLight),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(primaryColor),
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: Color(primaryColor)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: const Color(AppTheme.primaryColor),
        onPrimary: Colors.white,
        minimumSize: const Size.fromHeight(40),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Color(primaryColor)),
          selectedLabelStyle: TextStyle(color: Color(primaryColor))),
      useMaterial3: true);

  static final ThemeData darkTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(backgroundColorDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(primaryColor),
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: Color(primaryColor)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: const Color(AppTheme.primaryColor),
        onPrimary: Colors.white,
        minimumSize: const Size.fromHeight(40),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Color(primaryColor)),
          selectedLabelStyle: TextStyle(color: Color(primaryColor))),
      useMaterial3: true);
}
