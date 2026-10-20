import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/main_shell.dart';

/// ---------------------------------------------------------------------------
/// 🎬 SplashScreen — Açılış ve Karşılama Ekranı
/// ---------------------------------------------------------------------------
/// Uygulama ilk açıldığında gösterilen, logonun yumuşak bir şekilde büyüyerek
/// belirdiği (Fade & Scale) ve ardından ana kabuğa (MainShell) yönlendirdiği ekrandır.
///
/// 🔄 Neden StatefulWidget?
/// Çünkü bu ekranda:
/// 1. Bir zamanlayıcı (Timer) çalışır ve süre sonunda durumu değiştirir.
/// 2. Bir animasyon kontrolcüsü (AnimationController) her karede değeri günceller.
/// 3. Ekran kapandığında bu kaynakların bellekten (RAM) temizlenmesi (`dispose`) şarttır.
class SplashScreen extends StatefulWidget {
  final Duration duration;     // Açılış ekranının ekranda kalma süresi
  final bool autoNavigate;     // Süre bitince otomatik ana sayfaya geçilsin mi (testlerde false yapılabilir)?

  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2200),
    this.autoNavigate = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// 'SingleTickerProviderStateMixin':
/// Flutter'da animasyonların telefonun ekran yenileme hızıyla (genellikle 60Hz veya 120Hz)
/// kusursuz senkronize çalışabilmesi için bir 'Ticker' (zaman sayacı) gerekir.
/// 'vsync: this' parametresini kullanabilmek için bu mixin sınıfa dahil edilir.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController; // Animasyonun süresini ve oynatılmasını yönetir
  late Animation<double> _fadeAnimation;     // Opaklık (0.0 -> 1.0) geçişi
  late Animation<double> _scaleAnimation;    // Boyut (0.85 -> 1.0) büyüme geçişi
  Timer? _timer;                             // Otomatik geçiş sayacı

  /// 'initState()':
  /// Widget ağaca ilk eklendiğinde YALNIZCA BİR KEZ çalışan yaşam döngüsü (Lifecycle) metodudur.
  /// Animasyonların ve zamanlayıcıların başlatıldığı yerdir.
  @override
  void initState() {
    super.initState();

    // 1. Animasyon kontrolcüsünü 1200 milisaniye (1.2 sn) süreyle oluştur
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2. Opaklık animasyonu: easeIn eğrisiyle yumuşakça görünür
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    // 3. Boyut animasyonu: %85 boyuttan %100 boyuta, hafif yaylanma efektiyle (easeOutBack) büyür
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animasyonu başlat (0'dan 1'e doğru oynat)
    _animController.forward();

    // Belirlenen süre (2.2 sn) bitince otomatik ana sayfaya yönlendir
    if (widget.autoNavigate) {
      _timer = Timer(widget.duration, _navigateToHome);
    }
  }

  /// Ana Sayfaya Yönlendirme Fonksiyonu
  void _navigateToHome() {
    /// ⭐ Çok Kritik Flutter Kuralı: 'mounted' Kontrolü
    /// Zamanlayıcı tetiklendiğinde kullanıcı uygulamayı arka plana atmış veya kapatmış olabilir.
    /// Eğer widget artık ekranda değilse (`!mounted`) navigasyon yapmaya çalışmak hata verir.
    if (!mounted) return;

    _timer?.cancel();

    /// 'pushReplacement':
    /// Normal 'push' yerine kullanılır. Çünkü kullanıcı ana sayfaya ulaştığında
    /// Android'in geri butonuna bastığında tekrar Splash (Açılış) ekranına DÖNMEMELİDİR.
    /// 'pushReplacement' açılış ekranını yığından (Stack) siler ve yerine MainShell'i koyar.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Yumuşak kararma/açılma (Fade) geçiş efekti
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  /// 'dispose()':
  /// Widget ekrandan tamamen kaldırıldığında çalışan temizlik metodudur.
  /// Bellek Sızıntısını (Memory Leak) önlemek için arka plandaki Timer ve
  /// AnimationController mutlaka burada kapatılmalıdır!
  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F172A), // Premium gece safir tonu
      body: SafeArea(
        child: Stack(
          children: [
            // Arka plan ortam ışıltısı dekoratif daireleri (Görsel Zenginlik)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withOpacity(0.18),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentCyan.withOpacity(0.12),
                ),
              ),
            ),

            // Ana İçerik: Fade ve Scale animasyonlarıyla sarılmış merkez blok
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Kartı
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                            width: 1.5,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          // Eğer logo görseli yüklenemezse yedek (fallback) araç ikonu göster
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                size: 64,
                                color: AppColors.primaryBlueLight,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Zengin Metin (RichText): Marka İsmi 'Rota' beyaz, 'Rent' camgöbeği
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'Rota',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Rent',
                              style: TextStyle(color: Color(0xFF38BDF8)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Slogan
                      Text(
                        'Premium Araç Kiralama & Rezervasyon',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.75),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Yolculuğunuz Burada Başlar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.45),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Yükleme Göstergesi (Progress Indicator)
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          value: widget.autoNavigate ? null : 0.7,
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlueLight.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Kullanıcı beklemek istemezse sağ üstteki 'Atla →' Butonu
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _navigateToHome,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white.withOpacity(0.7),
                  backgroundColor: Colors.white.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
                child: const Text('Atla →', style: TextStyle(fontSize: 12)),
              ),
            ),

            // Sürüm ve Telif Bilgisi
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${AppConstants.appName} v1.0.0 • Türkiye',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

