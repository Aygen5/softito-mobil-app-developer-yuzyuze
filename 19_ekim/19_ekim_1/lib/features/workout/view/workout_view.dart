import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/workout_controller.dart';
import '../widget/add_workout_modal.dart';
import '../widget/workout_list_item.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: _buildAppBar(context),
          floatingActionButton: _buildFab(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutSummaryCardWidget(
                  totalCalories: controller.totalBurnedCalories,
                  goalCalories: controller.dailyCalorieGoal,
                  totalMinutes: controller.totalDurationMinutes,
                  progress: controller.progressRatio,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Bugünkü Antrenmanlar'),
                const SizedBox(height: 12),
                _buildWorkoutList(context),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Egzersiz & Kalori'),
      actions: [
        IconButton(
          tooltip: 'Günü Sıfırla',
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
          onPressed: controller.resetToday,
        ),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.neonLime,
      foregroundColor: AppColors.background,
      icon: const Icon(Icons.add),
      label: const Text('Antrenman Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: () => AddWorkoutModal.show(context, controller.addWorkout),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(fontSize: 16),
    );
  }

  Widget _buildWorkoutList(BuildContext context) {
    if (controller.workouts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'Henüz antrenman kaydı yok.',
            style: context.textTheme.bodyMedium,
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.workouts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final workout = controller.workouts[index];
        return WorkoutListItemWidget(
          workout: workout,
          onDelete: () => controller.removeWorkout(workout.id),
        );
      },
    );
  }
}
