import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 COLORS
  // 🎨 COLORS - Gromuse Inspired (Fresh & Clean)
  static const Color primaryColor = Color(0xFF27AE60); // Fresh Green
  static const Color accentColor = Color(0xFFFF8A65); // Soft Coral
  static const Color backgroundColor = Color(0xFFFAFAFA); // Clean Off-White
  static const Color surfaceColor = Colors.white;
  static const Color darkText = Color(0xFF263238); // Deep Blue Grey
  static const Color lightText = Color(0xFF9E9E9E); // Neutral Grey

  // ✍️ TYPOGRAPHY
  static TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: darkText,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: darkText,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: darkText,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: lightText,
    ),
  );

  // 🎭 THEME DATA
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
