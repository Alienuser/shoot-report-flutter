import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = 0xFF1B344C;
  static const accentColor = 0xFF0AE20A;
  static const greyColor = 0xFF858588;
  static const backgroundColorLight = 0xFFF2F2F7;
  static const backgroundColorDark = 0xFF2C2C2E;
  static const backgroundLight = 0xFFFDfCFF;
  static const backgroundDark = 0xFF1A1C1E;
  static const backgroundAdsLight = 0xFFFDFCFF;
  static const backgroundAdsDark = 0xFF706F6F;
  static const textSublineColor = 0xFF9C9CA0;
  static const lightTextColor = 0xFF000000;
  static const darkTextColor = 0xFFE2E2E6;
  static const chartWholeColor = 0x0AE20A;
  static const chartTenthColor = 0x0E2435;
  static const textColorDark = 0xFFFAFAFA;
  static const textColorLight = 0xFF363636;

  static final ThemeData lightTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(backgroundColorLight),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        backgroundColor: Color(primaryColor),
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: Color(primaryColor),
          unselectedLabelColor: Color(greyColor),
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
            width: 4,
            color: Color(primaryColor),
          ))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: const Color(AppTheme.primaryColor),
        onPrimary: Colors.white,
        minimumSize: const Size.fromHeight(40),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Color(primaryColor)),
        unselectedIconTheme: IconThemeData(color: Color(greyColor)),
        selectedItemColor: Color(primaryColor),
        unselectedItemColor: Color(greyColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Color(greyColor)),
      ),
      useMaterial3: true);

  static final ThemeData darkTheme = ThemeData(
      colorSchemeSeed: const Color(primaryColor),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(backgroundColorDark),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        backgroundColor: Color(primaryColor),
      ),
      tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Color(greyColor),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4, color: Color(accentColor)),
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: const Color(AppTheme.primaryColor),
        onPrimary: Colors.white,
        minimumSize: const Size.fromHeight(40),
      )),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Color(accentColor)),
        unselectedIconTheme: IconThemeData(color: Color(backgroundColorLight)),
        selectedItemColor: Color(accentColor),
        unselectedItemColor: Color(backgroundColorLight),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Color(textColorDark)),
      ),
      useMaterial3: true);
}
