import 'package:flutter/material.dart';

class ZenTheme {
  static const Color sage = Color(0xFF8FAE8B);
  static const Color deepSage = Color(0xFF5C7A5E);
  static const Color sand = Color(0xFFF5F0E8);
  static const Color warmBeige = Color(0xFFE8DDD0);
  static const Color stone = Color(0xFF9E9689);
  static const Color charcoal = Color(0xFF3D3D3D);
  static const Color softWhite = Color(0xFFFAF8F5);
  static const Color accent = Color(0xFFB8997A);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: sand,
      colorScheme: ColorScheme.light(
        primary: deepSage,
        secondary: sage,
        tertiary: accent,
        surface: softWhite,
        onPrimary: softWhite,
        onSecondary: charcoal,
        onSurface: charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: charcoal,
          fontSize: 20,
          fontWeight: FontWeight.w300,
          letterSpacing: 2.0,
        ),
        iconTheme: IconThemeData(color: charcoal),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: charcoal,
          fontSize: 32,
          fontWeight: FontWeight.w200,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          color: charcoal,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
        bodyLarge: TextStyle(
          color: charcoal,
          fontSize: 16,
          fontWeight: FontWeight.w300,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: stone,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: deepSage,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.0,
        ),
      ),
      cardTheme: CardThemeData(
        color: softWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: warmBeige, width: 1),
        ),
      ),
    );
  }
}
