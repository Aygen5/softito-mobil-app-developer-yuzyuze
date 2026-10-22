import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback? onAddProgress;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onAddProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (habit.isNotStarted) {
      return _buildNotStartedCard(context);
    }

    final isCompleted = habit.isCompletedToday;
    final ratio = habit.completionRatio;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: isCompleted
              ? AppColors.tertiary.withValues(alpha: 0.35)
              : AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst Satır: İkon + Başlık & Rozet + Eylem Butonu
          Row(
            children: [
              // İkon Kutusu
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
              const SizedBox(width: 12),

              // Başlık ve Etiket
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            habit.title,
                            style: AppTypography.headlineSmall.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildBadgeChip(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _buildSubtitleText(),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.secondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Tamamlama / Eylem Butonu
              _buildActionButton(),
            ],
          ),

          const SizedBox(height: 12),

          // İlerleme Çubuğu ve Durum Metni
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.fullRadius,
                  child: Container(
                    height: 8,
                    color: AppColors.surfaceContainerLowest,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: ratio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.tertiary
                              : Color(habit.colorValue),
                          borderRadius: AppRadius.fullRadius,
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: AppColors.tertiary.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _buildProgressStatusLabel(),
                style: AppTypography.labelCaps.copyWith(
                  color: isCompleted
                      ? AppColors.tertiary
                      : AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotStartedCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Icon(
                  IconData(
                    // ignore: non_const_argument_for_const_parameter
                    habit.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: AppColors.outline,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            habit.title,
                            style: AppTypography.headlineSmall.copyWith(
                              fontSize: 16,
                              color: AppColors.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            borderRadius: AppRadius.fullRadius,
                          ),
                          child: Text(
                            'Fitness',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bugün başlamak için harika bir gün',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Başlat Butonu
              IconButton(
                onPressed: onToggle,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                ),
                icon: const Icon(
                  Icons.play_arrow,
                  color: AppColors.outline,
                  size: 20,
                ),
                tooltip: 'Başlat',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: AppColors.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'İlk adımını atmaya hazır mısın?',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Text(
                'Henüz Başlanmadı',
                style: AppTypography.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeChip() {
    if (habit.id == 'step_10k') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withValues(alpha: 0.6),
          borderRadius: AppRadius.fullRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: AppColors.tertiary,
              size: 12,
            ),
            const SizedBox(width: 3),
            Text(
              '${habit.currentStreak} Gün Seri',
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      );
    } else if (habit.id == 'smoke_free') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: AppRadius.fullRadius,
        ),
        child: Text(
          'Sağlık',
          style: AppTypography.caption.copyWith(
            fontSize: 10,
            color: AppColors.primaryFixedDim,
          ),
        ),
      );
    } else if (habit.id == 'read_100p') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: AppRadius.fullRadius,
        ),
        child: Text(
          '2. Gün',
          style: AppTypography.caption.copyWith(
            fontSize: 10,
            color: AppColors.onSecondaryContainer,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: AppRadius.fullRadius,
      ),
      child: Text(
        habit.category.displayName,
        style: AppTypography.caption.copyWith(
          fontSize: 10,
          color: AppColors.tertiary,
        ),
      ),
    );
  }

  String _buildSubtitleText() {
    if (habit.id == 'step_10k') {
      return 'Hedef: 10.000 adım • Hareket';
    } else if (habit.id == 'smoke_free') {
      return 'Hedef: 30 gün • ${habit.challengeCurrentDay ?? 14} / ${habit.challengeTotalDays ?? 30} gün';
    } else if (habit.id == 'read_100p') {
      return '${habit.todayProgress.toInt()} / ${habit.targetValue.toInt()} sayfa • Kişisel Gelişim';
    } else if (habit.id == 'water_3l') {
      return '${habit.todayProgress.toInt()} / ${habit.targetValue.toInt()} ml • Hidrasyon';
    }
    return 'Hedef: ${habit.targetValue.toInt()} ${habit.targetUnit}';
  }

  Widget _buildActionButton() {
    if (habit.isCompletedToday) {
      return GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiary.withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.onTertiary,
            size: 20,
            weight: 700,
          ),
        ),
      );
    }

    if (onAddProgress != null) {
      return GestureDetector(
        onTap: onAddProgress,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: AppColors.secondary, size: 20),
        ),
      );
    }

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.radio_button_unchecked,
          color: AppColors.secondary,
          size: 20,
        ),
      ),
    );
  }

  String _buildProgressStatusLabel() {
    if (habit.isCompletedToday) return 'Tamamlandı';
    if (habit.id == 'smoke_free') {
      return '${habit.challengeCurrentDay}. Gün (%${(habit.completionRatio * 100).round()})';
    }
    if (habit.id == 'read_100p') {
      return '${habit.todayProgress.toInt()}/${habit.targetValue.toInt()} sf';
    }
    if (habit.id == 'water_3l') {
      return '${(habit.todayProgress / 1000).toStringAsFixed(1)}/${(habit.targetValue / 1000).toStringAsFixed(1)} L';
    }
    return '%${(habit.completionRatio * 100).round()}';
  }
}
