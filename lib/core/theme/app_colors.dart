import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette – teal / mint green
  static const Color primary = Color(0xFF2E7D6F);
  static const Color primaryLight = Color(0xFF80CBC4);
  static const Color primaryDark = Color(0xFF1B5E50);

  // Gradient stops (top → bottom)
  static const Color gradientTop = Color(0xFFB2DFDB);
  static const Color gradientBottom = Color(0xFF4D7C72);

  // Surface / Card / Overlay – cream
  static const Color surface = Color(0xFFFFF8E7);
  static const Color cardBackground = Color(0xFFFFF8E7);
  static const Color cardBackgroundLight = Color(0xFFFFF1D6);
  static const Color background = Color(0xFFE8F5F1);

  // Text
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textHint = Color(0xFF79747E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Dark sage green – for welcome text & overlay body text
  static const Color darkSageGreen = Color(0xFF3B5B4F);

  // Brand title color – dark navy blue
  static const Color brandTitle = Color(0xFF1B3A4B);

  // Accent
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFB00020);
  static const Color warning = Color(0xFFFFC107);

  // Timeline stage colors
  static const Color stageHarvesting = Color(0xFF66BB6A);
  static const Color stageDrying = Color(0xFFFFCA28);
  static const Color stageProcessing = Color(0xFF42A5F5);
  static const Color stageBottling = Color(0xFF2E7D6F);
  static const Color stageDistribution = Color(0xFFEF5350);

  // Divider
  static const Color divider = Color(0xFFD5D5D5);

  // Helper – standard gradient decoration
  static BoxDecoration get gradientBackground => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [gradientTop, gradientBottom],
    ),
  );
}
