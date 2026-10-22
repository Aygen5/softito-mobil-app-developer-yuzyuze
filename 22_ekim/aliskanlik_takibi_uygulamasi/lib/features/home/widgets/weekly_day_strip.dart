import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';

class WeeklyDayStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeeklyDayStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Seçili haftanın Pazartesi gününü bul
    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xlRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final dayDate = monday.add(Duration(days: index));
          final isSelected = AppDateUtils.isSameDay(dayDate, selectedDate);
          final weekdayLabel = AppDateUtils.weekdayShort(dayDate.weekday);

          return Expanded(
            child: GestureDetector(
              onTap: () => onDateSelected(dayDate),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceContainerHigh
                      : Colors.transparent,
                  borderRadius: AppRadius.mdRadius,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weekdayLabel,
                      style: AppTypography.labelCaps.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant.withValues(
                                alpha: 0.75,
                              ),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dayDate.day}',
                      style: AppTypography.labelNumeric.copyWith(
                        fontSize: 14,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Gösterge noktası (Yeşil / Nötr)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.tertiary
                            : (index < 4
                                  ? AppColors.tertiary.withValues(alpha: 0.7)
                                  : AppColors.outlineVariant),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.tertiary.withValues(
                                    alpha: 0.8,
                                  ),
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
        }),
      ),
    );
  }
}
