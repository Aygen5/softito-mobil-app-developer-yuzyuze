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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: AppColors.neonCyanGlow,
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCircularProgress(context),
          const SizedBox(height: 16),
          _buildGoalSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    final percentage = (progress * 100).toInt();
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 170,
            height: 170,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonCyan),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$consumedMl',
                style: context.textTheme.displayMedium?.copyWith(
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'ml / %$percentage',
                style: context.textTheme.labelSmall?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSubtitle(BuildContext context) {
    return Text(
      'Günlük Hedef: $goalMl ml',
      style: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
