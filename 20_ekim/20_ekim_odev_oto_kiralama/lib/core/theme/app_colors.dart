import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Marka Ana Renkleri
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1E3A8A);

  static const Color accentCyan = Color(0xFF0EA5E9);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);

  // Koyu Tema Yüzeyleri
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceElevated = Color(0xFF1F2937);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextMuted = Color(0xFF6B7280);

  // Açık Tema Yüzeyleri
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Kategori Etiket Renkleri
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Basic':
        return const Color(0xFF3B82F6);
      case 'Basic+':
        return const Color(0xFF0EA5E9);
      case 'Flex':
        return const Color(0xFF10B981);
      case 'Flex+':
        return const Color(0xFF14B8A6);
      case 'Lux':
        return const Color(0xFF8B5CF6);
      case 'Ultra Lux':
        return const Color(0xFFF59E0B);
      default:
        return primaryBlue;
    }
  }

  // Durum Renkleri
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Onaylandı':
        return successGreen;
      case 'Bekliyor':
        return accentAmber;
      case 'Tamamlandı':
        return const Color(0xFF6366F1);
      case 'İptal Edildi':
        return errorRed;
      default:
        return const Color(0xFF6B7280);
    }
  }
}
