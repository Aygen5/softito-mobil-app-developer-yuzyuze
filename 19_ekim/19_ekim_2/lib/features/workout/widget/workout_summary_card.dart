import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

class WorkoutSummaryCardWidget extends StatelessWidget {
  final int totalCalories;
  final int goalCalories;
  final int totalMinutes;
  final double progress;

  const WorkoutSummaryCardWidget({
    super.key,
    required this.totalCalories,
    required this.goalCalories,
    required this.totalMinutes,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: AppColors.neonLimeGlow,
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProgressLine(),
          const SizedBox(height: 16),
          _buildStatsRow(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bugün Yakılan',
              style: context.textTheme.labelSmall?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '$totalCalories',
                  style: context.textTheme.displayMedium?.copyWith(
                    color: AppColors.neonLime,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'kcal',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Icon(Icons.local_fire_department, color: AppColors.neonOrange, size: 36),
      ],
    );
  }

  Widget _buildProgressLine() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: AppColors.surfaceContainer,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hedef: $goalCalories kcal',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 16),
            const SizedBox(width: 4),
            Text(
              '$totalMinutes dk aktif',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
