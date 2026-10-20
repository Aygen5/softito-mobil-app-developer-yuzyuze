import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/splash/screens/splash_screen.dart';


/// RotaRentApp — Uygulamanın Kök (Root) Widget'ı

/// StatelessWidget:
/// Kendi içinde değiştirilebilir (mutable) bir durum (state) tutmayan widget'tır.
/// Bu widget'ın kendisi durum tutmaz; ancak aşağıda göreceğimiz'ValueListenableBuilder' sayesinde tema değişikliğini dinleyerek kendini yeniler.
class RotaRentApp extends StatelessWidget {
  
  /// 'initialHome':
  /// Normalde uygulama açılışta SplashScreen ile başlar.
  /// Ancak otomatik testler (Widget Tests) yazarken açılış ekranını (splash) atlayıp doğrudan ana sayfayı test edebilmek için bu opsiyonel parametre eklendi.
  final Widget? initialHome;

  const RotaRentApp({super.key, this.initialHome});

  @override
  Widget build(BuildContext context) {
    /// ValueListenableBuilder<ThemeMode>:
    /// Flutter'ın harici kütüphane gerektirmeyen reaktif (durum yönetimi) aracıdır.
    /// 'themeController' içindeki tema değeri (Açık/Koyu) değiştiğinde, SADECE bu builder bloğu tetiklenir ve MaterialApp yeni temayla yeniden çizilir.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {

        /// MaterialApp:
        /// Flutter uygulamasının genel yapılandırmasını (tema, başlık, yönlendirme, Material Design kuralları) sağlayan en üst seviye sarmalayıcıdır.
        return MaterialApp(
          // Uygulamanın işletim sistemi görev yöneticisinde görünen başlığı
          title: AppConstants.appName,

          // Sağ üstteki hata ayıklama (debug) şeridini gizler
          debugShowCheckedModeBanner: false,

          // Açık tema yapılandırmamız (Renkler, yazı tipleri, buton stilleri)
          theme: AppTheme.lightTheme,

          // Koyu tema yapılandırmamız
          darkTheme: AppTheme.darkTheme,

          // Şu an aktif olan tema modu (ThemeMode.light veya ThemeMode.dark)
          themeMode: themeMode,

          // Uygulama ilk açıldığında gösterilecek ekran
          // Eğer test için initialHome verilmişse o açılır, yoksa SplashScreen()
          home: initialHome ?? const SplashScreen(),
        );
      },
    );
  }
}

