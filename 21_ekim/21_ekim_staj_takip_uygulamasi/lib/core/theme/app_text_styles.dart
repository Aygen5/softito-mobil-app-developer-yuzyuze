import 'package:flutter/material.dart';

import 'app_colors.dart';

/// StajTakip uygulaması tipografi hiyerarşisi ve yazı stilleri.
abstract final class AppTextStyles {
  // Ekran Başlığı (26–30 px)
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // Bölüm / Kart Üstü Başlığı (18–21 px)
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  // Kart İçi / Vurgulu Başlık (16–17 px)
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  // Gövde Metni Standart (14–16 px)
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  // Gövde Metni Orta Ağırlık (14–16 px)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  // İkincil / Açıklama Metni (13–14 px)
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Küçük Etiket / Rozet / Tarih (12–13 px)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.3,
  );

  // Buton Metni (14–16 px)
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.2,
    height: 1.2,
  );

  // Form Input Etiketi
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Form İçi İpucu (Hint) Metni
  static const TextStyle inputHint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.3,
  );

  // Kısayol / Uyumluluk Takma Adları
  static const TextStyle h1 = screenTitle;
  static const TextStyle h2 = sectionTitle;
  static const TextStyle h3 = cardTitle;
  static const TextStyle bodySmall = subtitle;
  static const TextStyle label = inputLabel;
}
