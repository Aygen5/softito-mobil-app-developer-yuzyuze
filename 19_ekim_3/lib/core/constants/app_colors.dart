import 'package:flutter/material.dart';

/// Spor salonu ve hidrasyon paleti (Dark Obsidian & Neon + Light Slate & Neon)
abstract final class AppColors {
  // Arka plan ve yüzey renkleri (Dark Obsidian)
  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceContainer = Color(0xFF1F242C);
  static const Color card = Color(0xFF1A1F27);
  static const Color outline = Color(0xFF2E3440);

  // Arka plan ve yüzey renkleri (Light Slate & Clean White)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF1F5F9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFFE2E8F0);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF); // Su teması birincil (Dark)
  static const Color neonCyanDark = Color(0xFF0097A7); // Su teması birincil (Light mod için yüksek kontrast)
  static const Color neonCyanGlow = Color(0x3300E5FF);

  static const Color neonLime = Color(0xFFCCFF00); // Egzersiz & Kalori birincil (Dark)
  static const Color neonLimeDark = Color(0xFF65A30D); // Egzersiz & Kalori birincil (Light)
  static const Color neonLimeGlow = Color(0x33CCFF00);

  static const Color neonOrange = Color(0xFFFF6D00); // Yoğun egzersiz & yakılan kalori
  static const Color neonPurple = Color(0xFFB388FF); // İkincil aksan

  // İçecek Renkleri (Su, Çay, Kahve, Maden Suyu)
  static const Color beverageTea = Color(0xFF69F0AE); // Çay (Neon Nane/Yeşil)
  static const Color beverageTeaDark = Color(0xFF059669); // Çay (Açık mod)
  static const Color beverageCoffee = Color(0xFFFFB74D); // Kahve (Sıcak Karamel)
  static const Color beverageCoffeeDark = Color(0xFFB45309); // Kahve (Açık mod)
  static const Color beverageMineralWater = Color(0xFF18FFFF); // Maden Suyu (Buz Mavisi)
  static const Color beverageMineralWaterDark = Color(0xFF0284C7); // Maden Suyu (Açık mod)

  // Metin Renkleri (Dark)
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  // Metin Renkleri (Light)
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Durum Renkleri
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB00);
}
