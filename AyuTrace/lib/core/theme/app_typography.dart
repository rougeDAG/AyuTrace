import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineMedium =>
      GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get headlineSmall =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get titleLarge =>
      GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get titleSmall =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get bodyLarge =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall =>
      GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500);

  static TextStyle get brandTitle => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: 4,
  );
}
