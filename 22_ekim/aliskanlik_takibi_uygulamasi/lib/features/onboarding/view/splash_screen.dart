import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/brand_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Kısa süre (1.8 saniye) sonra karşılama / giriş ekranına yönlendirilir.
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go(RouteNames.welcome);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Koyu yeşil zemin
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1A11),
              Color(0xFF09120A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Uygulama Logosu
              const BrandLogo(size: 76),

              const SizedBox(height: 20),

              // Uygulama Adı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verdant',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 34,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                'ZİHİNSEL DİNGİNLİK & ALIŞKANLIK',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 2,
                  fontSize: 10,
                ),
              ),

              const Spacer(flex: 2),

              // Küçük Yükleniyor Göstergesi
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
