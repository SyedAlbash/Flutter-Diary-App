import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';

/// Dynamic AppColors that read from the currently active theme.
/// Falls back to Sky Blue defaults if ThemeController isn't registered yet
/// (e.g. during splash before GetX is ready).
class AppColors {
  static AppThemeData get _t {
    try {
      return ThemeController.to.currentTheme;
    } catch (_) {
      return ThemeController.themes[0]; // fallback: Sky Blue
    }
  }

  static Color get primary => _t.primary;
  static Color get primaryLight => _t.primaryLight;
  static Color get accent => _t.accent;
  static Color get background => _t.background;
  static Color get pinkBackground => _t.accent; // mapped to accent
  static Color get white => const Color(0xFFFFFFFF);
  static Color get textDark => _t.textDark;
  static Color get textGrey => _t.textGrey;
  static Color get cardBg => _t.cardBg;
  static Color get bottomNavBg => _t.bottomNavBg;
  static Color get pinCircle => _t.pinCircle;
  static Color get patternDot => _t.patternDot;
  static Color get scaffoldBackground => _t.scaffoldBackground;
  static List<Color> get gradientColors => _t.gradientColors;
  static String? get backgroundImage => _t.backgroundImage;
  static bool get isDark => _t.brightness == Brightness.dark;
}

class AppTheme {
  static ThemeData get theme {
    try {
      return ThemeController.to.themeData;
    } catch (_) {
      // Fallback before ThemeController is initialized
      return ThemeData(
        primaryColor: const Color(0xFF5B9BD5),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5B9BD5),
          secondary: Color(0xFFFFB6C1),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B9BD5),
            foregroundColor: const Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5B9BD5),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
        ),
      );
    }
  }
}
