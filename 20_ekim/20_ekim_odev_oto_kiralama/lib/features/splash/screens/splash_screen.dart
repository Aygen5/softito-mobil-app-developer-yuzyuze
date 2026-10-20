import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/main_shell.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final bool autoNavigate;

  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2200),
    this.autoNavigate = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();

    // Süre bitince ana ekrana geç
    if (widget.autoNavigate) {
      _timer = Timer(widget.duration, _navigateToHome);
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

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
            // Arka plan ortam ışıltısı
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

            // Ana İçerik
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

                      // Marka İsmi
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
                              style: TextStyle(color: Color(0xFF38BDF8)), // Sky/Cyan Blue
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

                      // Yükleme Göstergesi
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

            // Atla Butonu (Sağ Üst)
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

            // Alt Bilgi
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
