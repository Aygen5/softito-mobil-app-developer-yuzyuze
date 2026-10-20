import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🎨 AppColors — Merkezi Tasarım Sistemi Renk Paleti
/// ---------------------------------------------------------------------------
/// Flutter'da renkler 'Color(0xAARRGGBB)' formatında 16'lık (Hex) sayı tabanında tanımlanır:
/// - 0x: Dart dilinde sayının hexadecimal olduğunu belirtir.
/// - AA: Alpha (Opaklık) değeridir. 'FF' %100 tam opak, '00' ise tam saydam demektir.
/// - RR: Kırmızı (Red) kanalı (00 - FF)
/// - GG: Yeşil (Green) kanalı (00 - FF)
/// - BB: Mavi (Blue) kanalı (00 - FF)
///
/// Renkleri ayrı bir sınıfta toplamak; tasarım tutarlılığı sağlar ve gelecekte
/// marka rengi değiştiğinde onlarca widget'ı tek tek arama zahmetinden kurtarır.
class AppColors {
  /// Dışarıdan nesne oluşturulmasını engellemek için private constructor
  AppColors._();

  // ---------------------------------------------------------------------------
  // 🏢 Marka ve Vurgu Renkleri (Brand & Accent Colors)
  // ---------------------------------------------------------------------------
  static const Color primaryBlue = Color(0xFF1E40AF);       // Kurumsal derin mavi
  static const Color primaryBlueLight = Color(0xFF3B82F6);  // Koyu temada parlayan açık mavi
  static const Color primaryBlueDark = Color(0xFF1E3A8A);   // Vurgulu koyu mavi

  static const Color accentCyan = Color(0xFF0EA5E9);         // Canlı camgöbeği (Detaylar, ikonlar)
  static const Color accentAmber = Color(0xFFF59E0B);        // Uyarı ve bekleme sarısı
  static const Color successGreen = Color(0xFF10B981);       // Onay, başarı ve müsaitlik yeşili
  static const Color errorRed = Color(0xFFEF4444);           // Hata ve dolu gün kırmızısı

  // ---------------------------------------------------------------------------
  // 🌑 Koyu Tema (Dark Mode) Renkleri
  // ---------------------------------------------------------------------------
  /// Gözü yormayan modern antrasit/lacivert zemin tonları
  static const Color darkBackground = Color(0xFF0B0F19);     // En arka zemin rengi
  static const Color darkSurface = Color(0xFF111827);        // Kartlar ve paneller
  static const Color darkSurfaceElevated = Color(0xFF1F2937);// Bir tık daha açık yüzey (Input, chip)
  static const Color darkBorder = Color(0xFF374151);         // Kenarlık çizgileri
  static const Color darkTextPrimary = Color(0xFFF9FAFB);    // Birincil parlak beyaz metin
  static const Color darkTextSecondary = Color(0xFF9CA3AF);  // İkincil gri metin (alt açıklamalar)
  static const Color darkTextMuted = Color(0xFF6B7280);      // Sönük gri metin (ipucu/tarih)

  // ---------------------------------------------------------------------------
  // ☀️ Açık Tema (Light Mode) Renkleri
  // ---------------------------------------------------------------------------
  static const Color lightBackground = Color(0xFFF8FAFC);    // Ferah kırık beyaz zemin
  static const Color lightSurface = Color(0xFFFFFFFF);       // Saf beyaz kart zeminleri
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);// Hafif gri yükseltilmiş alanlar
  static const Color lightBorder = Color(0xFFE2E8F0);        // İnce kenarlık gri rengi
  static const Color lightTextPrimary = Color(0xFF0F172A);   // Okunabilir koyu lacivert metin
  static const Color lightTextSecondary = Color(0xFF475569); // İkincil açıklama metinleri
  static const Color lightTextMuted = Color(0xFF94A3B8);     // İpucu ve pasif buton metinleri

  // ---------------------------------------------------------------------------
  // 🏷️ Kategoriye Özel Dinamik Rozet Renkleri
  // ---------------------------------------------------------------------------
  /// Araç kartlarında aracın sınıfına (Basic, Flex, Lux vb.) göre
  /// farklı bir renk tonu döndüren yardımcı fonksiyon.
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Basic':
        return const Color(0xFF3B82F6); // Mavi
      case 'Basic+':
        return const Color(0xFF0EA5E9); // Camgöbeği
      case 'Flex':
        return const Color(0xFF10B981); // Zümrüt Yeşili
      case 'Flex+':
        return const Color(0xFF14B8A6); // Turkuaz
      case 'Lux':
        return const Color(0xFF8B5CF6); // Mor
      case 'Ultra Lux':
        return const Color(0xFFF59E0B); // Altın Sarısı
      default:
        return primaryBlue;
    }
  }

  // ---------------------------------------------------------------------------
  // 🚦 Rezervasyon Durumu Renkleri (Status Badges)
  // ---------------------------------------------------------------------------
  /// Rezervasyonun durumuna göre (Onaylandı, Bekliyor, İptal vb.)
  /// kullanıcıya anında görsel ipucu veren renk fonksiyonu.
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Onaylandı':
        return successGreen;
      case 'Bekliyor':
        return accentAmber;
      case 'Tamamlandı':
        return const Color(0xFF6366F1); // İndigo mavisi
      case 'İptal Edildi':
        return errorRed;
      default:
        return const Color(0xFF6B7280);
    }
  }
}

