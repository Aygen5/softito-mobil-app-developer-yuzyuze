import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../models/habit.dart';
import '../../habits/view/habit_form_sheet.dart';
import '../../profile/view/profile_modal_sheet.dart';
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
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => showProfileModal(context),
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

                  return _InteractiveCalendarHabitCard(
                    habit: h,
                    isDone: isDone,
                    selectedDate: state.selectedDate,
                    onToggle: () =>
                        cubit.toggleHabitCompletion(h.id, state.selectedDate),
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
        _InteractiveCalendarDay(
          day: day,
          date: cellDate,
          isSelected: isSelected,
          completedCount: completedCount,
          dotColor: dotColor,
          onTap: () => cubit.selectDate(cellDate),
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

class _InteractiveCalendarDay extends StatefulWidget {
  final int day;
  final DateTime date;
  final bool isSelected;
  final int completedCount;
  final Color dotColor;
  final VoidCallback onTap;

  const _InteractiveCalendarDay({
    required this.day,
    required this.date,
    required this.isSelected,
    required this.completedCount,
    required this.dotColor,
    required this.onTap,
  });

  @override
  State<_InteractiveCalendarDay> createState() => _InteractiveCalendarDayState();
}

class _InteractiveCalendarDayState extends State<_InteractiveCalendarDay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            isSelected ? -4 : (_isHovered ? -3 : 0),
            0,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondaryContainer
                : (_isHovered
                    ? AppColors.surfaceContainerHighest
                    : AppColors.surfaceContainerHigh),
            borderRadius: AppRadius.mdRadius,
            border: Border.all(
              color: isSelected
                  ? AppColors.tertiary
                  : (_isHovered
                      ? AppColors.tertiary.withValues(alpha: 0.7)
                      : Colors.transparent),
              width: isSelected || _isHovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              if (isSelected) ...[
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ] else if (_isHovered) ...[
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.day}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: isSelected || _isHovered
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryFixed
                      : (_isHovered ? AppColors.tertiary : AppColors.onSurface),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: isSelected || _isHovered ? 6 : 5,
                height: isSelected || _isHovered ? 6 : 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.tertiary : widget.dotColor,
                  boxShadow: (isSelected || _isHovered)
                      ? [
                          BoxShadow(
                            color: AppColors.tertiary.withValues(alpha: 0.8),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveCalendarHabitCard extends StatefulWidget {
  final Habit habit;
  final bool isDone;
  final DateTime selectedDate;
  final VoidCallback onToggle;

  const _InteractiveCalendarHabitCard({
    required this.habit,
    required this.isDone,
    required this.selectedDate,
    required this.onToggle,
  });

  @override
  State<_InteractiveCalendarHabitCard> createState() =>
      _InteractiveCalendarHabitCardState();
}

class _InteractiveCalendarHabitCardState
    extends State<_InteractiveCalendarHabitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final isDone = widget.isDone;
    final themeColor = Color(habit.colorValue);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            _isHovered ? -4 : 0,
            0,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isHovered
                    ? themeColor.withValues(alpha: 0.28)
                    : themeColor.withValues(alpha: 0.14),
                AppColors.surfaceContainer,
              ],
            ),
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: _isHovered
                  ? themeColor.withValues(alpha: 0.85)
                  : (isDone
                      ? AppColors.tertiary.withValues(alpha: 0.45)
                      : AppColors.outlineVariant.withValues(alpha: 0.35)),
              width: _isHovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              if (_isHovered) ...[
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ] else ...[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ],
          ),
          child: Row(
            children: [
              // İkon Kutusu
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: _isHovered ? 0.35 : 0.22),
                  borderRadius: AppRadius.smRadius,
                  border: Border.all(
                    color: themeColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Icon(
                  IconData(
                    habit.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: themeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Başlık ve Bilgi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            habit.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.2),
                            borderRadius: AppRadius.fullRadius,
                          ),
                          child: Text(
                            habit.category.displayName,
                            style: AppTypography.caption.copyWith(
                              fontSize: 9,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hedef: ${habit.targetValue.toInt()} ${habit.targetUnit} • ${habit.currentStreak} gün seri',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Durum Butonu / Rozeti
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.tertiaryContainer
                      : AppColors.surfaceContainerHigh,
                  borderRadius: AppRadius.fullRadius,
                  border: Border.all(
                    color: isDone
                        ? AppColors.tertiary.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isDone
                          ? AppColors.onTertiaryContainer
                          : AppColors.outline,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDone ? 'Tamamlandı' : 'Tamamlanmadı',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: isDone
                            ? AppColors.onTertiaryContainer
                            : AppColors.outline,
                        fontWeight: isDone
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
