import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Verdant Tipografi Sistemi (Manrope & Space Grotesk)
abstract class AppTypography {
  // Display & Headlines (Manrope)
  static TextStyle displayLarge = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    letterSpacing: -0.8,
  );

  static TextStyle headlineLarge = GoogleFonts.manrope(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: -0.5,
  );

  static TextStyle headlineMedium = GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: -0.3,
  );

  static TextStyle headlineSmall = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: -0.2,
  );

  // Body Texts (Manrope)
  static TextStyle bodyLarge = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle bodySmall = GoogleFonts.manrope(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  // Captions
  static TextStyle caption = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  // Structured Data & Numerics (Space Grotesk)
  static TextStyle labelNumeric = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle labelCaps = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.primary,
  );
}
