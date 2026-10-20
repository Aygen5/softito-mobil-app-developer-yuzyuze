import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🌓 ThemeController — Uygulama Teması Durum Yöneticisi
/// ---------------------------------------------------------------------------
/// `ValueNotifier<T>`:
/// Flutter'ın ChangeNotifier yapısının tek bir değer tutan özel, hafif versiyonudur.
/// 'value' özelliği her değiştiğinde kendisini dinleyen widget'lara otomatik olarak
/// "ben değiştim, kendini yeniden çiz" sinyali gönderir.
///
/// Bu sayede 'Bloc', 'Provider' veya 'Riverpod' gibi harici paketler eklemeden
/// tüm uygulamada anında açık/koyu tema geçişini sağlarız.
class ThemeController extends ValueNotifier<ThemeMode> {
  /// Başlangıçta varsayılan olarak açık tema (ThemeMode.light) ile başlatılır.
  ThemeController({ThemeMode initialMode = ThemeMode.light}) : super(initialMode);

  /// Kolaylık sağlayan yardımcı getter (Koyu modda mıyız?)
  bool get isDarkMode => value == ThemeMode.dark;

  /// Temayı tersine çevirir (Açık ise Koyu, Koyu ise Açık yapar)
  void toggleTheme() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir temayı doğrudan atar
  void setTheme(ThemeMode mode) {
    if (value != mode) {
      value = mode;
    }
  }
}

/// Uygulama genelinde tek bir tema kontrol noktası olması için
/// 'Singleton / Global Top-Level Variable' olarak tanımlandı.
/// Böylece hem AccountScreen'deki switch hem de app.dart'taki MaterialApp aynı nesneyi dinler.
final ThemeController themeController = ThemeController();

