import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/habit.dart';
import '../cubit/habits_cubit.dart';
import '../cubit/habits_state.dart';
import 'habit_form_sheet.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  void _openFormModal(BuildContext context, [Habit? habit]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HabitFormSheet(habitToEdit: habit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        titleSpacing: AppSpacing.margin,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.smRadius,
              ),
              child: const Icon(Icons.spa, color: AppColors.tertiary, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VERDANT',
                  style: AppTypography.labelCaps.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Alışkanlıklarım',
                  style: AppTypography.headlineSmall.copyWith(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openFormModal(context),
            icon: const Icon(Icons.add, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainer,
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.margin),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HabitsCubit, HabitsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RUTİNLER & DÜZEN',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text('Tüm Alışkanlıkların', style: AppTypography.headlineLarge),
                Text(
                  'Düzenlemek veya detaylarını görmek için bir alışkanlığa dokun.',
                  style: AppTypography.bodySmall,
                ),

                const SizedBox(height: 20),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.habits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final habit = state.habits[index];
                    return _buildHabitManageCard(context, habit);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormModal(context),
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildHabitManageCard(BuildContext context, Habit habit) {
    return GestureDetector(
      onTap: () => _openFormModal(context, habit),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(habit.colorValue).withValues(alpha: 0.2),
                borderRadius: AppRadius.mdRadius,
              ),
              child: Center(
                child: Icon(
                  IconData(
                    // ignore: non_const_argument_for_const_parameter
                    habit.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Color(habit.colorValue),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Hedef: ${habit.targetValue.toInt()} ${habit.targetUnit}',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: AppTypography.caption),
                      const SizedBox(width: 8),
                      Text(
                        habit.category.displayName,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  if (habit.reminderEnabled && habit.reminderTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hatırlatıcı: ${habit.reminderTime}',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
