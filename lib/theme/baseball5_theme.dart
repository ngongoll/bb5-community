import 'package:flutter/material.dart';

/// Baseball5 Theme (Brand Guidelines Version 2025)
///
/// Voraussetzung: Fonts "Klavika" und "Champion" sind in der pubspec.yaml
/// registriert (siehe vorherige Anleitung).
class B5Colors {
  B5Colors._();

  /// Pantone 108C – RGB 255/218/0
  static const Color yellow = Color(0xFFFFDA00);

  /// Pantone Black 7C – RGB 61/57/53
  static const Color dark = Color(0xFF3D3935);

  static const Color white = Color(0xFFFFFFFF);

  /// Heller Grauton wie in den Kopfzeilen des Guides (Schätzwert)
  static const Color lightGrey = Color(0xFFEAEAEA);

  /// Mittelgrau für Sekundärtext (Schätzwert)
  static const Color midGrey = Color(0xFF8A8580);

  // Akzentfarben aus den grafischen Elementen des Guides.
  // ACHTUNG: Das sind geschätzte Werte, keine offiziellen Brand-Farben.
  static const Color accentTeal = Color(0xFF1FBDB5);
  static const Color accentPink = Color(0xFFE8386D);
  static const Color accentBlue = Color(0xFF5AA9E6);
  static const Color accentGreen = Color(0xFFB5D93C);
}

class B5Fonts {
  B5Fonts._();
  static const String klavika = 'Klavika';
  static const String champion = 'Champion';
}

class B5Theme {
  B5Theme._();

  // ---------- Typografie ----------
  // Champion = Titel (im Guide meist GROSSBUCHSTABEN, nur eine Stärke vorhanden)
  // Klavika  = Fließtext / UI (Regular 400, Medium 500, Bold 700)
  static TextTheme _textTheme(Color color) {
    return TextTheme(
      // Große Titel -> Champion
      displayLarge: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 56,
        height: 1.0,
        color: color,
      ),
      displayMedium: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 44,
        height: 1.0,
        color: color,
      ),
      displaySmall: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 36,
        height: 1.05,
        color: color,
      ),
      headlineLarge: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 32,
        height: 1.1,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 28,
        height: 1.1,
        color: color,
      ),
      headlineSmall: TextStyle(
        fontFamily: B5Fonts.champion,
        fontWeight: FontWeight.normal,
        fontSize: 24,
        height: 1.1,
        color: color,
      ),

      // Zwischenüberschriften -> Klavika Bold
      titleLarge: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: color,
      ),
      titleMedium: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: color,
      ),
      titleSmall: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: color,
      ),

      // Fließtext -> Klavika Regular
      bodyLarge: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.4,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.4,
        color: color,
      ),
      bodySmall: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.4,
        color: color,
      ),

      // Buttons, Tabs, Chips -> Klavika Bold
      labelLarge: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0.5,
        color: color,
      ),
      labelMedium: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        letterSpacing: 0.4,
        color: color,
      ),
      labelSmall: TextStyle(
        fontFamily: B5Fonts.klavika,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.4,
        color: color,
      ),
    );
  }

  // ---------- Heller Modus ----------
  // Weißer Hintergrund, dunkle Schrift, gelb als Akzent,
  // dunkle AppBar wie im Brand Guide (Header: dunkel + gelb).
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: B5Colors.yellow,
      onPrimary: B5Colors.dark,
      secondary: B5Colors.dark,
      onSecondary: B5Colors.yellow,
      tertiary: B5Colors.accentTeal,
      onTertiary: B5Colors.dark,
      error: Color(0xFFD32F2F),
      onError: B5Colors.white,
      surface: B5Colors.white,
      onSurface: B5Colors.dark,
      surfaceContainerHighest: B5Colors.lightGrey,
      outline: B5Colors.midGrey,
    );
    return _build(scheme);
  }

  // ---------- Dunkler Modus ----------
  // Dunkelbraun (#3D3935) als Hintergrund, gelbe Akzente.
  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: B5Colors.yellow,
      onPrimary: B5Colors.dark,
      secondary: B5Colors.yellow,
      onSecondary: B5Colors.dark,
      tertiary: B5Colors.accentTeal,
      onTertiary: B5Colors.dark,
      error: Color(0xFFEF5350),
      onError: B5Colors.dark,
      surface: B5Colors.dark,
      onSurface: B5Colors.white,
      surfaceContainerHighest: Color(0xFF4A4540),
      outline: B5Colors.midGrey,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    final isLight = scheme.brightness == Brightness.light;
    final textTheme = _textTheme(scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: B5Fonts.klavika,
      textTheme: textTheme,

      // AppBar: immer dunkel mit gelbem Titel (Brand-Look)
      appBarTheme: AppBarTheme(
        backgroundColor: B5Colors.dark,
        foregroundColor: B5Colors.yellow,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: B5Fonts.champion,
          fontWeight: FontWeight.normal,
          fontSize: 28,
          color: B5Colors.yellow,
        ),
        iconTheme: const IconThemeData(color: B5Colors.yellow),
      ),

      // Gelbe Hauptbuttons mit dunkler Schrift
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: B5Colors.yellow,
          foregroundColor: B5Colors.dark,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: B5Colors.yellow,
          foregroundColor: B5Colors.dark,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isLight ? B5Colors.dark : B5Colors.yellow,
          side: BorderSide(
            color: isLight ? B5Colors.dark : B5Colors.yellow,
            width: 2,
          ),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? B5Colors.dark : B5Colors.yellow,
          textStyle: textTheme.labelLarge,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: B5Colors.yellow,
        foregroundColor: B5Colors.dark,
      ),

      // Eingabefelder
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        labelStyle: textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: B5Colors.yellow, width: 2),
        ),
      ),

      // Bottom Navigation: dunkel mit gelber Auswahl
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: B5Colors.dark,
        selectedItemColor: B5Colors.yellow,
        unselectedItemColor: B5Colors.midGrey,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: B5Colors.dark,
        indicatorColor: B5Colors.yellow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? B5Colors.dark
                : B5Colors.white,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? B5Colors.yellow
                : B5Colors.white,
          );
        }),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: B5Colors.yellow,
        labelStyle: textTheme.labelMedium,
        side: BorderSide.none,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: B5Colors.yellow,
        unselectedLabelColor: B5Colors.white,
        indicatorColor: B5Colors.yellow,
        labelStyle: textTheme.labelLarge,
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outline.withOpacity(0.3),
        thickness: 1,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: B5Colors.yellow,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? B5Colors.dark
                : B5Colors.midGrey),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? B5Colors.yellow
                : B5Colors.lightGrey),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Verwendung in main.dart:
//
// import 'baseball5_theme.dart';
//
// MaterialApp(
//   title: 'Baseball5',
//   theme: B5Theme.light(),
//   darkTheme: B5Theme.dark(),
//   themeMode: ThemeMode.system,
//   home: const HomePage(),
// );
//
// Beispiel Titel (im Guide in GROSSBUCHSTABEN):
//
// Text(
//   'WATCH THE BEST OF THE BASEBALL5',
//   style: Theme.of(context).textTheme.headlineLarge,
// );
// ---------------------------------------------------------------------------
