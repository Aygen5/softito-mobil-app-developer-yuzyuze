import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../../core/widgets/yorunge_logo.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/view/login_view.dart';
import '../../shell/view/shell_view.dart';

class SplashScreen extends StatefulWidget {
  final ThemeController themeController;
  final AuthController? authController;

  const SplashScreen({
    super.key,
    required this.themeController,
    this.authController,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();

    // 2.4 saniye sonra oturum durumuna göre uygun ekrana geçiş yap
    _timer = Timer(const Duration(milliseconds: 2400), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    final auth = widget.authController;
    final isAuthenticated = auth?.isAuthenticated ?? false;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => isAuthenticated
            ? ShellView(
                themeController: widget.themeController,
                authController: auth,
              )
            : LoginView(
                themeController: widget.themeController,
                authController: auth ?? AuthController(),
              ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
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
    final colors = context.spaceColors;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StarfieldBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const YorungeLogo(size: 110),
                  const SizedBox(height: 28),
                  // Logo Başlığı (YÖRÜNGE)
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          colors.rocketFlame,
                          colors.nebulaCyan,
                          colors.ascensionLime,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Y Ö R Ü N G E',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Girişimcilik Platformu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: colors.nebulaCyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fikirden Şirketleşmeye Kesintisiz Destek',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Yükleme Göstergesi
                  SizedBox(
                    width: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: colors.surfaceSubtle,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.rocketFlame,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ekosistem Hazırlanıyor...',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
