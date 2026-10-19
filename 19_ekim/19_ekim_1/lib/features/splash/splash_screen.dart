import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../beverage_tracker/controller/beverage_tracker_controller.dart';
import '../dashboard/dashboard_shell.dart';
import '../workout/controller/workout_controller.dart';

class SplashScreen extends StatefulWidget {
  final BeverageTrackerController beverageController;
  final WorkoutController workoutController;

  const SplashScreen({
    super.key,
    required this.beverageController,
    required this.workoutController,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    _timer = Timer(const Duration(milliseconds: 2200), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) => DashboardShell(
          beverageController: widget.beverageController,
          workoutController: widget.workoutController,
        ),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoImage(),
                const SizedBox(height: 24),
                _buildAppTitle(context),
                const SizedBox(height: 8),
                _buildSubtitle(context),
                const SizedBox(height: 36),
                _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoImage() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: AppColors.neonCyanGlow,
            blurRadius: 36,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: AppColors.neonLimeGlow,
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    return Text(
      'SUSADIM',
      style: context.textTheme.displayMedium?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: 6,
        color: AppColors.neonCyan,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Akıllı Hidrasyon & Fitness Takibi',
      style: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonLime),
      ),
    );
  }
}
