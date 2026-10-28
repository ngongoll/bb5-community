import 'package:flutter/material.dart';

class AppBrandColors {
  static const Color primary = Color(0xFF0E5A4A);
  static const Color primaryDark = Color(0xFF0A3F35);
  static const Color accent = Color(0xFFF5B84B);
  static const Color background = Color(0xFFF5F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF17312E);
  static const Color mutedText = Color(0xFF546B67);
  static const Color line = Color(0xFFE4EAE5);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppBrandColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppBrandColors.primary,
        brightness: Brightness.light,
        primary: AppBrandColors.primary,
        secondary: AppBrandColors.accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppBrandColors.text,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppBrandColors.surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: AppBrandColors.line,
      textTheme: Typography.material2021().black.copyWith(
        displayLarge: const TextStyle(
          color: AppBrandColors.text,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: const TextStyle(
          color: AppBrandColors.text,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          color: AppBrandColors.text,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: const TextStyle(
          color: AppBrandColors.text,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(color: AppBrandColors.text),
        bodyMedium: const TextStyle(color: AppBrandColors.mutedText),
      ),
    );

    return base.copyWith(
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F1720),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppBrandColors.primary,
        brightness: Brightness.dark,
        primary: AppBrandColors.primary,
        secondary: AppBrandColors.accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF16252E),
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: const Color(0xFF2E3C42),
      textTheme: Typography.material2021().white.copyWith(
        displayLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Color(0xFFB0C1C9)),
      ),
    );

    return base.copyWith(
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
