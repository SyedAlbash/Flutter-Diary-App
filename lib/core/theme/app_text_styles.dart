import 'package:flutter/material.dart';

/// Custom text styles using locally bundled fonts
/// This replaces google_fonts package to reduce app size
class AppTextStyles {
  // Poppins styles (primary font)
  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double letterSpacing = 0,
    double height = 1.0,
    TextDecoration decoration = TextDecoration.none,
    String fontFamily = 'Poppins',
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  // Pacifico style (decorative font for splash)
  static TextStyle pacifico({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.bold,
    Color color = Colors.black,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: 'Pacifico',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Yellowtail style (decorative font)
  static TextStyle yellowtail({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: 'Yellowtail',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Lily Script One style
  static TextStyle lilyScriptOne({
    double fontSize = 31.67,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
    double letterSpacing = 0.3167, // 1% of 31.67
    double height = 1.367, // 43.3 / 31.67
  }) {
    return TextStyle(
      fontFamily: 'LilyScriptOne',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Common preset styles
  static TextStyle get largeHeading => poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading => poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get subheading => poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get body => poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
      );
}
