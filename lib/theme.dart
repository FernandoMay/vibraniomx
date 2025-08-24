// ```

// ## lib/core/theme/app_theme.dart
// ```dart
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF1A1625);
  static const Color primary = Color(0xFF8B5FFF);
  static const Color secondary = Color(0xFF4FC3F7);
  static const Color accent = Color(0xFF00E5FF);
  static const Color textPrimary = Color(0xFFF5F3FF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color yinAccent = Color(0xFF6366F1);
  static const Color yangAccent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFFBBF24);

  // Gradients
  static const LinearGradient yinGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6B73FF)],
  );

  static const LinearGradient yangGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFF6B9D)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0F), Color(0xFF1A1625), Color(0xFF0A0A0F)],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
    );
  }
}