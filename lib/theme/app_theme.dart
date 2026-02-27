import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightBackground,
    fontFamily: 'Urbanist',

    colorScheme: const ColorScheme.light(
      primary: AppColor.primary,
      background: AppColor.lightBackground,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightBackground,
      elevation: 0,
      foregroundColor: Colors.black,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.lightBackground,
      selectedItemColor: AppColor.primary,
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackground,
    fontFamily: 'Urbanist',

    colorScheme: const ColorScheme.dark(
      background: AppColor.darkBackground,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkBackground,
      elevation: 0,
      foregroundColor: Colors.black,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.darkBackground,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
    ),
  );
}