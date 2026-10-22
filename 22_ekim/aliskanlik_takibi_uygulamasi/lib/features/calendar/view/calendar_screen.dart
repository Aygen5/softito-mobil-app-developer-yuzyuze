import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../habits/view/habit_form_sheet.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../widgets/activity_heatmap.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

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
                  'Takvim',
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
      body: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          final cubit = context.read<CalendarCubit>();
          final monthTitle = AppDateUtils.formatMonthYear(state.selectedMonth);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık Bloğu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RİTÜEL & DÖNGÜ',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'İlerlemeni gün gün keşfet.',
                          style: AppTypography.headlineMedium.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.tertiary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '%${(state.monthSuccessRatio * 100).round()} Bu Ay',
                            style: AppTypography.labelNumeric.copyWith(
                              fontSize: 12,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Filtreleme Çipleri
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Tüm Alışkanlıklar',
                        isSelected: state.filterHabitId == 'all',
                        onTap: () => cubit.setFilter('all'),
                      ),
                      ...state.habits.map((h) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildFilterChip(
                            label: h.title,
                            isSelected: state.filterHabitId == h.id,
                            onTap: () => cubit.setFilter(h.id),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Aylık Takvim Bölümü
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: AppRadius.xlRadius,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Ay Kontrol Başlığı
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                monthTitle,
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: cubit.previousMonth,
                                icon: const Icon(Icons.chevron_left, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                onPressed: cubit.nextMonth,
                                icon: const Icon(Icons.chevron_right, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Gün İsimleri
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                                .map(
                                  (d) => Expanded(
                                    child: Center(
                                      child: Text(
                                        d,
                                        style: AppTypography.labelCaps.copyWith(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),

                      const SizedBox(height: 10),

                      // Günler Matrisi (7x5)
                      _buildCalendarDaysGrid(state, cubit),

                      const SizedBox(height: 14),

                      // Açıklama / Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem('Tamamlandı', AppColors.tertiary),
                          _buildLegendItem('Kısmi', AppColors.secondary),
                          _buildLegendItem(
                            'Yapılmadı',
                            AppColors.outline.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Isı Haritası (Activity Heatmap)
                ActivityHeatmap(completions: state.allCompletions),

                const SizedBox(height: 20),

                // Seçilen Günün Alışkanlık Detayları
                Text(
                  '${state.selectedDate.day} ${AppDateUtils.formatMonthYear(state.selectedDate)} Alışkanlıkları',
                  style: AppTypography.headlineSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ...state.habits.map((h) {
                  final isDone = state.allCompletions.any(
                    (c) =>
                        c.habitId == h.id &&
                        AppDateUtils.isSameDay(c.date, state.selectedDate) &&
                        c.isCompleted,
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: AppRadius.lgRadius,
                      border: Border.all(
                        color: isDone
                            ? AppColors.tertiary.withValues(alpha: 0.3)
                            : AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconData(
                            // ignore: non_const_argument_for_const_parameter
                            h.iconCodePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Color(h.colorValue),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            h.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppColors.tertiaryContainer
                                : AppColors.surfaceContainerHigh,
                            borderRadius: AppRadius.fullRadius,
                          ),
                          child: Text(
                            isDone ? 'Tamamlandı' : 'Tamamlanmadı',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: isDone
                                  ? AppColors.onTertiaryContainer
                                  : AppColors.outline,
                              fontWeight: isDone
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 36),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerHigh,
          borderRadius: AppRadius.fullRadius,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: isSelected
                ? AppColors.onPrimaryContainer
                : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDaysGrid(CalendarState state, CalendarCubit cubit) {
    final year = state.selectedMonth.year;
    final month = state.selectedMonth.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday; // 1 = Monday ... 7 = Sunday

    final daysInPrevMonth = DateTime(year, month, 0).day;

    final cells = <Widget>[];

    // Önceki aydan kalan günler
    for (int i = startWeekday - 1; i > 0; i--) {
      cells.add(
        Center(
          child: Text(
            '${daysInPrevMonth - i + 1}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
    }

    // Bu ayın günleri
    for (int day = 1; day <= daysInMonth; day++) {
      final cellDate = DateTime(year, month, day);
      final isSelected = AppDateUtils.isSameDay(cellDate, state.selectedDate);

      // Tamamlanma durumu
      final dayComps = state.allCompletions.where((c) {
        if (state.filterHabitId != 'all' && c.habitId != state.filterHabitId) {
          return false;
        }
        return AppDateUtils.isSameDay(c.date, cellDate);
      }).toList();

      final completedCount = dayComps.where((c) => c.isCompleted).length;
      Color dotColor = AppColors.outline.withValues(alpha: 0.4);

      if (completedCount >= 3) {
        dotColor = AppColors.tertiary;
      } else if (completedCount >= 1) {
        dotColor = AppColors.secondary;
      }

      cells.add(
        GestureDetector(
          onTap: () => cubit.selectDate(cellDate),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.secondaryContainer
                  : AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.mdRadius,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.tertiary.withValues(alpha: 0.35),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primaryFixed
                        : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.tertiary : dotColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sonraki aydan tamamlayıcı günler
    int nextMonthDay = 1;
    while (cells.length % 7 != 0) {
      cells.add(
        Center(
          child: Text(
            '$nextMonthDay',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
      nextMonthDay++;
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      children: cells,
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
