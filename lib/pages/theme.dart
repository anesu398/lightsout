import 'package:flutter/material.dart';

class RiveAppTheme {
  static const Color accentColor = Color(0xFF0A84FF);
  static const Color background = Color(0xFFF5F5F7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color borderSubtle = Color(0xFFE5E5EA);
  static const Color surfaceMuted = Color(0xFFF2F2F7);
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color danger = Color(0xFFFF453A);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
    );
  }
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 25;
}

class AppRadii {
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double pill = 999;
  static const Color shadow = Color(0xFF8E8E93);
  static const Color shadowDark = Color(0xFF000000);
  static const Color background = Color(0xFFF5F5F7);
  static const Color backgroundDark = Color(0xFF1C1C1E);
  static const Color background2 = Color(0xFF2C2C2E);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color secondaryLabel = Color(0xFF6E6E73);
}
