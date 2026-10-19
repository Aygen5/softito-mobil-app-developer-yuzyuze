import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

class WorkoutListItemWidget extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback onDelete;

  const WorkoutListItemWidget({
    super.key,
    required this.workout,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hour = workout.timestamp.hour.toString().padLeft(2, '0');
    final minute = workout.timestamp.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          _buildIconBadge(),
          const SizedBox(width: 14),
          _buildInfo(context, hour, minute),
          const Spacer(),
          _buildCalories(context),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Icon(workout.type.icon, color: AppColors.neonLime, size: 22),
    );
  }

  Widget _buildInfo(BuildContext context, String hour, String minute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.type.label,
          style: context.textTheme.titleLarge?.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(
          '${workout.durationMinutes} dakika • $hour:$minute',
          style: context.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildCalories(BuildContext context) {
    return Text(
      '${workout.caloriesBurned} kcal',
      style: context.textTheme.titleLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.neonOrange,
      ),
    );
  }
}
