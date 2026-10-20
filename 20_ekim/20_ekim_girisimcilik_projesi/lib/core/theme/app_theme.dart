import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Yörünge projesine özel semantik renk genişletmesi (ThemeExtension).
/// Bütün renk erişimleri context.spaceColors üzerinden sağlanır.
class SpaceColors extends ThemeExtension<SpaceColors> {
  final Color spaceBlack;
  final Color nightBlue;
  final Color surfaceDark;
  final Color surfaceSubtle;
  final Color border;
  final Color rocketFlame;
  final Color nebulaCyan;
  final Color ascensionLime;
  final Color starPurple;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color glowBorder;
  final Color warningAmber;
  final Color errorRed;

  const SpaceColors({
    required this.spaceBlack,
    required this.nightBlue,
    required this.surfaceDark,
    required this.surfaceSubtle,
    required this.border,
    required this.rocketFlame,
    required this.nebulaCyan,
    required this.ascensionLime,
    required this.starPurple,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.glowBorder,
    required this.warningAmber,
    required this.errorRed,
  });

  @override
  SpaceColors copyWith({
    Color? spaceBlack,
    Color? nightBlue,
    Color? surfaceDark,
    Color? surfaceSubtle,
    Color? border,
    Color? rocketFlame,
    Color? nebulaCyan,
    Color? ascensionLime,
    Color? starPurple,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? glowBorder,
    Color? warningAmber,
    Color? errorRed,
  }) {
    return SpaceColors(
      spaceBlack: spaceBlack ?? this.spaceBlack,
      nightBlue: nightBlue ?? this.nightBlue,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      border: border ?? this.border,
      rocketFlame: rocketFlame ?? this.rocketFlame,
      nebulaCyan: nebulaCyan ?? this.nebulaCyan,
      ascensionLime: ascensionLime ?? this.ascensionLime,
      starPurple: starPurple ?? this.starPurple,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      glowBorder: glowBorder ?? this.glowBorder,
      warningAmber: warningAmber ?? this.warningAmber,
      errorRed: errorRed ?? this.errorRed,
    );
  }

  @override
  SpaceColors lerp(ThemeExtension<SpaceColors>? other, double t) {
    if (other is! SpaceColors) return this;
    return SpaceColors(
      spaceBlack: Color.lerp(spaceBlack, other.spaceBlack, t) ?? spaceBlack,
      nightBlue: Color.lerp(nightBlue, other.nightBlue, t) ?? nightBlue,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t) ?? surfaceDark,
      surfaceSubtle:
          Color.lerp(surfaceSubtle, other.surfaceSubtle, t) ?? surfaceSubtle,
      border: Color.lerp(border, other.border, t) ?? border,
      rocketFlame: Color.lerp(rocketFlame, other.rocketFlame, t) ?? rocketFlame,
      nebulaCyan: Color.lerp(nebulaCyan, other.nebulaCyan, t) ?? nebulaCyan,
      ascensionLime:
          Color.lerp(ascensionLime, other.ascensionLime, t) ?? ascensionLime,
      starPurple: Color.lerp(starPurple, other.starPurple, t) ?? starPurple,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      glowBorder: Color.lerp(glowBorder, other.glowBorder, t) ?? glowBorder,
      warningAmber:
          Color.lerp(warningAmber, other.warningAmber, t) ?? warningAmber,
      errorRed: Color.lerp(errorRed, other.errorRed, t) ?? errorRed,
    );
  }

  // --- KARANLIK TEMA ÖZELLEŞTİRMESİ ("Derin Uzay") ---
  static const SpaceColors dark = SpaceColors(
    spaceBlack: AppColors.spaceBlack,
    nightBlue: AppColors.nightBlue,
    surfaceDark: AppColors.surfaceDark,
    surfaceSubtle: Color(0xFF1E294B),
    border: AppColors.borderDark,
    rocketFlame: AppColors.rocketFlame,
    nebulaCyan: AppColors.nebulaCyan,
    ascensionLime: AppColors.ascensionLime,
    starPurple: AppColors.starPurple,
    textPrimary: AppColors.textDarkPrimary,
    textSecondary: AppColors.textDarkSecondary,
    textMuted: AppColors.textDarkMuted,
    glowBorder: Color(0x3322D3EE),
    warningAmber: AppColors.warningAmber,
    errorRed: AppColors.errorRed,
  );

  // --- AYDINLIK TEMA ÖZELLEŞTİRMESİ ("Şafak Fırlatışı") ---
  static const SpaceColors light = SpaceColors(
    spaceBlack: AppColors.dawnBackground,
    nightBlue: AppColors.dawnSurface,
    surfaceDark: AppColors.dawnSurface,
    surfaceSubtle: AppColors.dawnSurfaceSubtle,
    border: AppColors.borderLight,
    rocketFlame: AppColors.rocketFlame,
    nebulaCyan: Color(0xFF0284C7),
    ascensionLime: Color(0xFF65A30D),
    starPurple: Color(0xFF7C3AED),
    textPrimary: AppColors.textLightPrimary,
    textSecondary: AppColors.textLightSecondary,
    textMuted: Color(0xFF64748B),
    glowBorder: Color(0x220284C7),
    warningAmber: AppColors.warningAmber,
    errorRed: AppColors.errorRed,
  );
}

/// ThemeData tanımları (Material 3).
abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.spaceBlack,
      canvasColor: AppColors.nightBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.rocketFlame,
        secondary: AppColors.nebulaCyan,
        tertiary: AppColors.ascensionLime,
        surface: AppColors.nightBlue,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.textDarkPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.nightBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.nightBlue,
        selectedColor: AppColors.rocketFlame.withValues(alpha: 0.25),
        labelStyle: const TextStyle(
          color: AppColors.textDarkPrimary,
          fontSize: 13,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.rocketFlame,
          fontWeight: FontWeight.bold,
        ),
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rocketFlame,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.nebulaCyan,
          side: const BorderSide(color: AppColors.nebulaCyan),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.nightBlue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.nebulaCyan, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textDarkMuted,
          fontSize: 14,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[SpaceColors.dark],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.dawnBackground,
      canvasColor: AppColors.dawnSurface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.rocketFlame,
        secondary: Color(0xFF0284C7),
        tertiary: Color(0xFF65A30D),
        surface: AppColors.dawnSurface,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textLightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.textLightPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.dawnSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.dawnSurface,
        selectedColor: AppColors.rocketFlame.withValues(alpha: 0.15),
        labelStyle: const TextStyle(
          color: AppColors.textLightPrimary,
          fontSize: 13,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.rocketFlame,
          fontWeight: FontWeight.bold,
        ),
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rocketFlame,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF0284C7),
          side: const BorderSide(color: Color(0xFF0284C7)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.dawnSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      ),
      extensions: const <ThemeExtension<dynamic>>[SpaceColors.light],
    );
  }
}
