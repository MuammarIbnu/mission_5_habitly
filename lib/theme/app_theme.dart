import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2FB969);
  static const Color lightBackground = Color(0xFFE3FFDB);
  static const Color darkBackground = Color(0xFFA7A7A7);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primaryGreen,
    fontFamily: 'Urbanist',
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: darkBackground,
    fontFamily: 'Urbanist',
    brightness: Brightness.dark,
  );
}