import 'package:flutter/material.dart';

/// Yörünge platformunda desteklenen beş temel kullanıcı rolü.
enum UserRole {
  /// 1. Girişimci: Fikir geliştiren, mentor ve yatırım arayan kurucu.
  entrepreneur,

  /// 2. Yatırımcı: Girişimleri inceleyen ve yatırım fırsatlarını değerlendiren fon/melek.
  investor,

  /// 3. Mentor: Girişimcilere danışmanlık ve sektörel rehberlik sağlayan uzman.
  mentor,

  /// 4. Program Sağlayıcısı: Hibe, kuluçka ve hızlandırma programları sunan kurum temsilcisi.
  programProvider,

  /// 5. Platform Yöneticisi: Ekosistem ve kullanıcı süreçlerini yöneten yetkili.
  admin;

  /// Rolün Türkçe arayüz başlığı
  String get displayName {
    switch (this) {
      case UserRole.entrepreneur:
        return 'Girişimci';
      case UserRole.investor:
        return 'Yatırımcı';
      case UserRole.mentor:
        return 'Mentor';
      case UserRole.programProvider:
        return 'Kurum Temsilcisi';
      case UserRole.admin:
        return 'Platform Yöneticisi';
    }
  }

  /// Rolün kısa sorumluluk tanımı
  String get description {
    switch (this) {
      case UserRole.entrepreneur:
        return 'İş planı hazırlayan, fikir geliştiren ve yatırım arayan kurucu.';
      case UserRole.investor:
        return 'Girişimleri inceleyen, fonlama ve ortaklık fırsatlarını değerlendiren yatırımcı.';
      case UserRole.mentor:
        return 'Derin teknoloji ve iş geliştirme süreçlerinde danışmanlık sağlayan uzman.';
      case UserRole.programProvider:
        return 'Kamu hibe ve hızlandırma desteklerini yöneten kurum temsilcisi.';
      case UserRole.admin:
        return 'Tüm ekosistem akışlarını, onay süreçlerini ve rolleri yöneten sistem yetkilisi.';
    }
  }

  /// Rolü temsil eden Material ikonu
  IconData get icon {
    switch (this) {
      case UserRole.entrepreneur:
        return Icons.rocket_launch_rounded;
      case UserRole.investor:
        return Icons.trending_up_rounded;
      case UserRole.mentor:
        return Icons.psychology_rounded;
      case UserRole.programProvider:
        return Icons.account_balance_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  /// JSON / String değerinden UserRole çözümleme (geriye dönük uyumluluk dahil)
  static UserRole fromString(String? value) {
    if (value == null) return UserRole.entrepreneur;
    final lower = value.toLowerCase().trim();

    for (final role in UserRole.values) {
      if (role.name.toLowerCase() == lower) return role;
    }

    if (lower.contains('yatirim') || lower.contains('investor')) {
      return UserRole.investor;
    }
    if (lower.contains('mentor')) {
      return UserRole.mentor;
    }
    if (lower.contains('kurum') ||
        lower.contains('program') ||
        lower.contains('provider')) {
      return UserRole.programProvider;
    }
    if (lower.contains('admin') || lower.contains('yonetici')) {
      return UserRole.admin;
    }

    return UserRole.entrepreneur;
  }
}
