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
    final timeStr =
        '${workout.timestamp.hour.toString().padLeft(2, '0')}:${workout.timestamp.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.neonLimeGlow,
            child: Icon(workout.type.icon, color: AppColors.neonLime, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.type.label,
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 15),
                ),
                Text(
                  '${workout.durationMinutes} dk • $timeStr',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${workout.caloriesBurned} kcal',
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  color: AppColors.neonOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
