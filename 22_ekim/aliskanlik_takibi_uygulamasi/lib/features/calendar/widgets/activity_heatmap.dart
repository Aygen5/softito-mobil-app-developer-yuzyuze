import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/habit_completion.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<HabitCompletion> completions;

  const ActivityHeatmap({super.key, required this.completions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yıllık Alışkanlık Isı Haritası',
                    style: AppTypography.headlineSmall.copyWith(fontSize: 16),
                  ),
                  Text(
                    'Son 12 haftalık istikrar ritmi',
                    style: AppTypography.caption,
                  ),
                ],
              ),
              const Icon(Icons.insights, color: AppColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 14),

          // 7 satır x 12 sütun ızgara
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(12, (colIdx) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    children: List.generate(7, (rowIdx) {
                      final cellScore = (colIdx * 3 + rowIdx * 5) % 5;
                      Color cellColor;

                      if (cellScore == 0) {
                        cellColor = AppColors.surfaceContainerHigh;
                      } else if (cellScore == 1) {
                        cellColor = AppColors.secondaryContainer;
                      } else if (cellScore == 2) {
                        cellColor = AppColors.tertiaryContainer;
                      } else {
                        cellColor = AppColors.tertiary;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
