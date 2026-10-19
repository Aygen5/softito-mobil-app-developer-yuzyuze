import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

class WaterProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final int consumedMl;
  final int goalMl;

  const WaterProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.consumedMl,
    required this.goalMl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundGlow(),
          _buildCircularProgress(),
          _buildCenterStats(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Container(
      width: 220,
      height: 220,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyanGlow,
            blurRadius: 36,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 14,
        backgroundColor: AppColors.surfaceContainer,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildCenterStats(BuildContext context) {
    final percent = (progress * 100).toInt();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 32),
        const SizedBox(height: 4),
        Text(
          '$consumedMl ml',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '%$percent / $goalMl ml',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
