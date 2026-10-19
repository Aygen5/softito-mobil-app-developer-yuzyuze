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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: AppColors.neonLimeGlow,
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProgressBar(),
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
        Row(
          children: [
            const Icon(Icons.local_fire_department, color: AppColors.neonOrange, size: 28),
            const SizedBox(width: 8),
            Text(
              'Aktif Kalori',
              style: context.textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
          ],
        ),
        Text(
          '$totalCalories / $goalCalories kcal',
          style: context.textTheme.titleLarge?.copyWith(
            color: AppColors.neonLime,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, Icons.timer_outlined, '$totalMinutes dk', 'Toplam Süre'),
        Container(width: 1, height: 28, color: AppColors.outline),
        _buildStatItem(
          context,
          Icons.percent,
          '%${(progress * 100).toInt()}',
          'Hedef Oranı',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.neonLime),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: context.textTheme.titleLarge?.copyWith(fontSize: 14)),
            Text(label, style: context.textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}
