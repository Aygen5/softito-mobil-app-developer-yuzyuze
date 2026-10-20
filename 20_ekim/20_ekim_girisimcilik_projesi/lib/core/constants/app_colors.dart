import 'package:flutter/material.dart';

/// Ham renk tanımları.
/// Kural gereği (project.md) widget'lar içinde doğrudan Color(0xFF...) kullanılmaz;
/// renkler AppTheme ve ThemeExtension (SpaceColors) üzerinden tüketilir.
abstract final class AppColors {
  // --- DERİN UZAY (Karanlık Tema) ---
  static const Color spaceBlack = Color(0xFF05070F);
  static const Color nightBlue = Color(0xFF0C1224);
  static const Color surfaceDark = Color(0xFF131B33);
  static const Color borderDark = Color(0xFF1E294B);

  // --- ŞAFAK FIRLATIŞI (Aydınlık Tema) ---
  static const Color dawnBackground = Color(0xFFF4F7FC);
  static const Color dawnSurface = Color(0xFFFFFFFF);
  static const Color dawnSurfaceSubtle = Color(0xFFE8EEF8);
  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color textLightPrimary = Color(0xFF0B132B);
  static const Color textLightSecondary = Color(0xFF475569);

  // --- VURGU RENKLERİ (Accent Palette) ---
  static const Color rocketFlame = Color(0xFFFF6B2C); // Roket ateşi turuncusu
  static const Color nebulaCyan = Color(0xFF22D3EE); // Nebula camgöbeği
  static const Color ascensionLime = Color(0xFFA3E635); // Yükseliş limonu
  static const Color starPurple = Color(0xFF8B5CF6); // Yıldız moru
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  // --- METİN RENKLERİ (Karanlık) ---
  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color textDarkMuted = Color(0xFF64748B);
}
