import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ---------------------------------------------------------------------------
/// 🎭 AppTheme — Material Design 3 Tema Konfigürasyonu
/// ---------------------------------------------------------------------------
/// Flutter'da modern arayüz tasarımı ThemeData ve ColorScheme üzerine kurulur.
///
/// Material 3 (M3) Nedir?
/// Google'ın en güncel tasarım dilidir. `useMaterial3: true` ile aktif edilir.
/// M3; daha yuvarlatılmış köşeler (BorderRadius), tonal renk paletleri ve
/// gelişmiş kart/buton/input stilleri sunar.
///
/// Bu dosyada hem 'lightTheme' hem de 'darkTheme' tanımlanarak, tüm uygulamanın
/// tek bir noktadan tutarlı ve profesyonel görünmesi sağlanır.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // ☀️ Açık Tema (Light Theme)
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme {
    /// ColorScheme.light:
    /// Material 3'ün temel renk rollerini belirler:
    /// - primary: Ana marka rengi (aktif butonlar, başlıklar)
    /// - onPrimary: Ana rengin üzerine yazılacak metin rengi (örn: buton içi beyaz yazı)
    /// - surface: Kartların, dialogların ve menülerin arka plan rengi
    /// - onSurface: Surface zeminindeki yazıların rengi
    /// - outline: Kenarlık (border) çizgisi rengi
    final colorScheme = ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFDBEAFE),
      onPrimaryContainer: const Color(0xFF1E3A8A),
      secondary: AppColors.accentCyan,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceVariant: AppColors.lightSurfaceElevated,
      onSurfaceVariant: AppColors.lightTextSecondary,
      error: AppColors.errorRed,
      onError: Colors.white,
      outline: AppColors.lightBorder,
    );

    return ThemeData(
      // Material 3 standartlarını zorunlu kıl
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      // Sayfaların en alt arka plan rengi (Scaffold)
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: null, // Sistem varsayılan yazı tipini kullan (SF Pro / Roboto)

      // Üst Başlık Çubuğu (AppBar) Stili
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Şeffaf arka plan
        elevation: 0,                       // Gölgesiz, düz modern görünüm
        scrolledUnderElevation: 0,          // Sayfa kaydırılınca gölge eklenmesini engelle
        centerTitle: false,                 // Başlığı sola yasla
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Kart (Card) Bileşeni Stili
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0, // Düz kart, derinlik yerine ince kenarlık çizgisi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dolgulu Buton (ElevatedButton) Stili
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, 48), // Parmak dostu dokunmatik hedef boyutu (min 48px)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Kenarlıklı Buton (OutlinedButton) Stili
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Metin Giriş Alanları (TextField / TextFormField) Teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: const TextStyle(
          color: AppColors.lightTextMuted,
          fontSize: 14,
        ),
      ),

      // Modal Diyalog Penceresi Teması
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
      ),

      // Alttan Açılan Sayfa (BottomSheet) Teması
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        modalBackgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Ayırıcı Çizgi (Divider) Teması
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🌑 Koyu Tema (Dark Theme)
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    /// ColorScheme.dark:
    /// Koyu tema için zeminleri antrasit/siyah, yazıları açık renk yapar.
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryBlueLight,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryBlueDark,
      onPrimaryContainer: const Color(0xFFDBEAFE),
      secondary: AppColors.accentCyan,
      onSecondary: Colors.black,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceVariant: AppColors.darkSurfaceElevated,
      onSurfaceVariant: AppColors.darkTextSecondary,
      error: AppColors.errorRed,
      onError: Colors.white,
      outline: AppColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: null,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueLight,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlueLight,
          side: const BorderSide(color: AppColors.primaryBlueLight, width: 1.5),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlueLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: const TextStyle(
          color: AppColors.darkTextMuted,
          fontSize: 14,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        modalBackgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}

