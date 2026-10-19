import 'package:flutter/material.dart';

/// Gece spor salonu paleti (Dark Obsidian & Neon) renk sabitleri
abstract final class AppColors {
  // Arka plan ve yüzey renkleri (Dark Obsidian)
  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceContainer = Color(0xFF1F242C);
  static const Color card = Color(0xFF1A1F27);
  static const Color outline = Color(0xFF2E3440);

  // Neon Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF); // Su teması birincil
  static const Color neonCyanGlow = Color(0x3300E5FF);
  static const Color neonLime = Color(0xFFCCFF00); // Egzersiz & Kalori birincil
  static const Color neonLimeGlow = Color(0x33CCFF00);
  static const Color neonOrange = Color(0xFFFF6D00); // Yoğun egzersiz & yakılan kalori
  static const Color neonPurple = Color(0xFFB388FF); // İkincil aksan

  // İçecek Renkleri (Su, Çay, Kahve, Maden Suyu)
  static const Color beverageTea = Color(0xFF69F0AE); // Çay (Neon Nane/Yeşil)
  static const Color beverageCoffee = Color(0xFFFFB74D); // Kahve (Sıcak Karamel)
  static const Color beverageMineralWater = Color(0xFF18FFFF); // Maden Suyu (Buz Mavisi)

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);

  // Durum Renkleri
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB00);
}
