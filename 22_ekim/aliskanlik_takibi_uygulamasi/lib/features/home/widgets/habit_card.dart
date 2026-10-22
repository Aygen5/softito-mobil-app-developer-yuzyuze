import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/habit.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback? onStart;
  final VoidCallback? onAddProgress;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onStart,
    this.onAddProgress,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.habit.isNotStarted) {
      return _buildNotStartedCard(context);
    }

    final habit = widget.habit;
    final isCompleted = habit.isCompletedToday;
    final ratio = habit.completionRatio;
    final themeColor = Color(habit.colorValue);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          // Seçilen tema rengini kartın tamamına canlı ve belirgin şekilde yayıyoruz
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withValues(
                alpha: isCompleted ? 0.85 : (_isHovered ? 0.76 : 0.65),
              ),
              themeColor.withValues(
                alpha: isCompleted ? 0.65 : (_isHovered ? 0.52 : 0.42),
              ),
              AppColors.surfaceContainer.withValues(alpha: 0.75),
            ],
          ),
          borderRadius: AppRadius.xlRadius,
          border: Border.all(
            color: isCompleted
                ? AppColors.tertiary
                : (_isHovered
                    ? themeColor
                    : themeColor.withValues(alpha: 0.75)),
            width: isCompleted || _isHovered ? 1.8 : 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? AppColors.tertiary.withValues(alpha: 0.35)
                  : themeColor.withValues(alpha: _isHovered ? 0.45 : 0.22),
              blurRadius: _isHovered ? 18 : 10,
              offset: Offset(0, _isHovered ? 6 : 3),
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
                    color: themeColor.withValues(alpha: 0.3),
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      IconData(
                        habit.iconCodePoint,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: themeColor,
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
                          _buildBadgeChip(habit, themeColor),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _buildSubtitleText(habit),
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
                _buildActionButton(habit, isCompleted, themeColor),
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
                                : themeColor,
                            borderRadius: AppRadius.fullRadius,
                            boxShadow: isCompleted
                                ? [
                                    BoxShadow(
                                      color: AppColors.tertiary.withValues(alpha: 0.6),
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
                  _buildProgressStatusLabel(habit, isCompleted),
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
      ),
    );
  }

  Widget _buildNotStartedCard(BuildContext context) {
    final habit = widget.habit;
    final themeColor = Color(habit.colorValue);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withValues(alpha: _isHovered ? 0.65 : 0.45),
              themeColor.withValues(alpha: _isHovered ? 0.40 : 0.25),
              AppColors.surfaceContainer.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: AppRadius.xlRadius,
          border: Border.all(
            color: _isHovered
                ? themeColor
                : themeColor.withValues(alpha: 0.65),
            width: _isHovered ? 1.6 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: _isHovered ? 0.35 : 0.18),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
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
                      habit.iconCodePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: AppColors.primary,
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
                              habit.category.displayName,
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
                // Başlat Butonu - Basıldığında başlatılır
                ElevatedButton.icon(
                  onPressed: widget.onStart ?? widget.onToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.fullRadius,
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text(
                    'Başlat',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
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
      ),
    );
  }

  Widget _buildBadgeChip(Habit habit, Color themeColor) {
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
          '14/30 Gün',
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
        color: themeColor.withValues(alpha: 0.25),
        borderRadius: AppRadius.fullRadius,
      ),
      child: Text(
        habit.category.displayName,
        style: AppTypography.caption.copyWith(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _buildSubtitleText(Habit habit) {
    if (habit.id == 'step_10k') {
      return 'Hedef: 10.000 adım • Hareket';
    } else if (habit.id == 'smoke_free') {
      return 'Hedef: 30 gün • ${habit.challengeCurrentDay ?? 14} / ${habit.challengeTotalDays ?? 30} gün';
    } else if (habit.id == 'read_100p') {
      return '${habit.todayProgress.toInt()} / ${habit.targetValue.toInt()} sayfa • Kişisel Gelişim';
    } else if (habit.id == 'water_3l') {
      return '${habit.todayProgress.toInt()} / ${habit.targetValue.toInt()} ml • Hidrasyon';
    }
    return 'Hedef: ${habit.targetValue.toInt()} ${habit.targetUnit} • ${habit.category.displayName}';
  }

  Widget _buildActionButton(Habit habit, bool isCompleted, Color themeColor) {
    if (isCompleted) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onToggle,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.45),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.onTertiary,
              size: 22,
              weight: 700,
            ),
          ),
        ),
      );
    }

    // İlerleme eklenebilen alışkanlıklar için + butonu ve tamamlama
    if (widget.onAddProgress != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // + Ekle Butonu
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onAddProgress,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Check/Tamamlama Butonu
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onToggle,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.outline,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onToggle,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: const Icon(
            Icons.radio_button_unchecked,
            color: AppColors.secondary,
            size: 22,
          ),
        ),
      ),
    );
  }

  String _buildProgressStatusLabel(Habit habit, bool isCompleted) {
    if (isCompleted) return 'Tamamlandı';
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
