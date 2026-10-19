import 'package:flutter/material.dart';

/// Sessiz Defter / Günlüğüm tasarım sistemine ait renk paleti.
/// Stitch tasarımındaki tonlara uygun olarak oluşturulmuştur.
class AppColors {
  AppColors._();

  // Zemin & Yüzey Renkleri
  static const Color background = Color(0xFFFEF8F6);
  static const Color surface = Color(0xFFFEF8F6);
  static const Color surfaceContainer = Color(0xFFF2EDEB);
  static const Color surfaceContainerLow = Color(0xFFF8F2F0);
  static const Color surfaceContainerHigh = Color(0xFFEDE7E5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  // Vurgu & Marka Renkleri (Adaçayı / Sage)
  static const Color primary = Color(0xFF485949);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF607260);

  static const Color secondary = Color(0xFF516352);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD1E5CF);
  static const Color onSecondaryContainer = Color(0xFF556756);

  static const Color tertiary = Color(0xFF6A4D54);

  // Metin & Çizgi Renkleri
  static const Color onSurface = Color(0xFF1D1B1A);
  static const Color onSurfaceVariant = Color(0xFF434842);
  static const Color outline = Color(0xFF747872);
  static const Color outlineVariant = Color(0xFFE6E0D6);

  // Durum Renkleri
  static const Color success = Color(0xFF485949);
}
