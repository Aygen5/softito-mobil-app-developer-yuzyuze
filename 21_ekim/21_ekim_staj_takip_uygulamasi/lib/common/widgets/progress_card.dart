import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/workday_calculator.dart';
import 'app_card.dart';

/// Staj ilerleme durumunu gösteren görsel kart bileşeni.
class ProgressCard extends StatelessWidget {
  final int completedDays;
  final int requiredDays;
  final String title;
  final String? subtitle;
  final double? progressRatio;

  const ProgressCard({
    super.key,
    required this.completedDays,
    required this.requiredDays,
    this.title = 'Staj İlerlemesi',
    this.subtitle,
    this.progressRatio,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRatio =
        progressRatio ??
        WorkdayCalculator.calculateProgressRatio(
          completedDays: completedDays,
          requiredDays: requiredDays,
        );
    final percentage = WorkdayCalculator.calculateProgressPercentage(
      completedDays: completedDays,
      requiredDays: requiredDays,
    );

    return AppCard(
      backgroundColor: AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '%$percentage',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // İlerleme Çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: effectiveRatio,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentTeal,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$completedDays',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' / $requiredDays Gün Tamamlandı',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    subtitle!,
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
