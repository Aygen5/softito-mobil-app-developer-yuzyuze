import 'package:flutter/material.dart';

/// Verdant Design System Renk Paleti
/// Stitch `DESIGN.md` ve `design-system.md` dokümanlarına birebir sadık kalınmıştır.
abstract class AppColors {
  // Arka Plan ve Yüzeyler
  static const Color surface = Color(0xFF0F150F);
  static const Color background = Color(0xFF0F150F);
  static const Color surfaceDim = Color(0xFF0F150F);
  static const Color surfaceBright = Color(0xFF343B34);
  static const Color surfaceContainerLowest = Color(0xFF0A100A);
  static const Color surfaceContainerLow = Color(0xFF171D17);
  static const Color surfaceContainer = Color(0xFF1B211B);
  static const Color surfaceContainerHigh = Color(0xFF252C25);
  static const Color surfaceContainerHighest = Color(0xFF30362F);

  // Metin Renkleri
  static const Color onSurface = Color(0xFFDEE4DA);
  static const Color onSurfaceVariant = Color(0xFFC6C8BB);
  static const Color textPrimary = Color(0xFFF2F0E6);
  static const Color textSecondary = Color(0xFFA8B2A3);
  static const Color textMuted = Color(0xFF6F7B6E);

  // Birincil Marka (Adaçayı / Haki)
  static const Color primary = Color(0xFFBDCD9C);
  static const Color primaryContainer = Color(0xFF87966A);
  static const Color onPrimary = Color(0xFF283412);
  static const Color onPrimaryContainer = Color(0xFF222E0C);
  static const Color primaryFixed = Color(0xFFD9E9B7);
  static const Color primaryFixedDim = Color(0xFFBDCD9C);

  // İkincil Renkler
  static const Color secondary = Color(0xFFBCCCA6);
  static const Color secondaryContainer = Color(0xFF404D30);
  static const Color onSecondary = Color(0xFF273419);
  static const Color onSecondaryContainer = Color(0xFFAEBE98);
  static const Color secondaryFixed = Color(0xFFD8E8C0);
  static const Color secondaryFixedDim = Color(0xFFBCCCA6);

  // Üçüncül / Büyüme Yeşili (Habit Completion / Growth Green)
  static const Color tertiary = Color(0xFF9AD594);
  static const Color tertiaryContainer = Color(0xFF659E62);
  static const Color onTertiary = Color(0xFF00390B);
  static const Color onTertiaryContainer = Color(0xFF003209);
  static const Color tertiaryFixed = Color(0xFFB5F2AE);
  static const Color tertiaryFixedDim = Color(0xFF9AD594);

  // Çizgi ve Kontur
  static const Color outline = Color(0xFF909286);
  static const Color outlineVariant = Color(0xFF45483E);

  // Durum Renkleri
  static const Color inProgress = Color(0xFFD7B66D); // Amber
  static const Color warning = Color(0xFFDFA477);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color lavenderAccent = Color(0xFFC1A7D9);
}
