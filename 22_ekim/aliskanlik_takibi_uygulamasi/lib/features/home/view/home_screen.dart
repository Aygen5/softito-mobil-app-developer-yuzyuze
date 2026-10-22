import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../habits/view/habit_form_sheet.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/habit_card.dart';
import '../widgets/hydration_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/weekly_day_strip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const HabitFormSheet(),
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
                  'Ana Sayfa',
                  style: AppTypography.headlineSmall.copyWith(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openAddHabitModal(context),
            icon: const Icon(Icons.add, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainer,
              shape: const CircleBorder(),
            ),
            tooltip: 'Hızlı Ekle',
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          final dateStr = AppDateUtils.formatTurkishFullDate(
            state.selectedDate,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarih ve Karşılama
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr.toUpperCase(),
                          style: AppTypography.labelCaps.copyWith(
                            letterSpacing: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Merhaba, Aygen',
                          style: AppTypography.headlineLarge.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: AppColors.onSurfaceVariant,
                            size: 22,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.tertiary.withValues(
                                    alpha: 0.8,
                                  ),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Haftalık Gün Şeridi
                WeeklyDayStrip(
                  selectedDate: state.selectedDate,
                  onDateSelected: cubit.selectDate,
                ),

                const SizedBox(height: 18),

                // Günlük İlerleme Kahraman Kartı
                DailyProgressCard(progress: state.dailyProgress),

                const SizedBox(height: 16),

                // Hidrasyon Kartı
                HydrationCard(
                  currentMl: state.waterConsumed,
                  targetMl: state.waterTarget,
                  onAddWater: cubit.addWaterGlass,
                ),

                const SizedBox(height: 16),

                // İlham Kartı
                QuoteCard(
                  quote: state.currentQuote,
                  onNextQuote: cubit.cycleQuote,
                ),

                const SizedBox(height: 24),

                // Bölüm Başlığı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bugünün Alışkanlıkları',
                          style: AppTypography.headlineSmall,
                        ),
                        Text(
                          'Kendin için ayırdığın zaman.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: Text(
                        '${state.habits.length} Alışkanlık',
                        style: AppTypography.labelCaps.copyWith(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Alışkanlık Kartları Listesi
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.habits.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final habit = state.habits[index];
                    return HabitCard(
                      habit: habit,
                      onToggle: () => cubit.toggleHabit(habit.id),
                      onAddProgress: habit.id == 'read_100p'
                          ? () => cubit.addReadPages(15)
                          : habit.id == 'water_3l'
                          ? cubit.addWaterGlass
                          : null,
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddHabitModal(context),
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimaryContainer,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
