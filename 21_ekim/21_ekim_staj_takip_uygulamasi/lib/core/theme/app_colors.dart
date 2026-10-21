import 'package:flutter/material.dart';

/// StajTakip uygulaması kurumsal renk paleti ve tasarım token'ları.
abstract final class AppColors {
  // Ana Vurgular ve Kurumsal Renkler
  static const primaryNavy = Color(0xFF142D4E);
  static const primaryBlue = Color(0xFF246BFD);
  static const accentTeal = Color(0xFF20A486);

  // Arka Plan ve Yüzeyler
  static const background = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF8FAFC);

  // Metin Renkleri
  static const textPrimary = Color(0xFF182538);
  static const textSecondary = Color(0xFF69778B);
  static const textMuted = Color(0xFF94A3B8);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // Kenarlık ve Ayırıcılar
  static const border = Color(0xFFE3EAF2);
  static const borderLight = Color(0xFFF1F5F9);
  static const divider = Color(0xFFE2E8F0);

  // Durum Renkleri (Geri bildirim ve rozetler için)
  static const success = Color(0xFF16845B);
  static const successLight = Color(0xFFE8F5EE);

  static const warning = Color(0xFFC78116);
  static const warningLight = Color(0xFFFFF7EB);

  static const error = Color(0xFFC64747);
  static const errorLight = Color(0xFFFDEEEE);

  static const info = Color(0xFF1E88E5);
  static const infoLight = Color(0xFFE3F2FD);

  // Gölgeler
  static const shadow = Color(0x0D000000);
  static const shadowMedium = Color(0x1A142D4E);
}
