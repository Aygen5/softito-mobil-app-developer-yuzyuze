import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/achievement.dart';
import '../../habits/view/habit_form_sheet.dart';
import '../cubit/statistics_cubit.dart';
import '../cubit/statistics_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

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
                  'İstatistikler',
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
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          final cubit = context.read<StatisticsCubit>();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alt Başlık ve Farkındalık
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'HAFTALIK RAPOR',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Gelişimini Keşfet', style: AppTypography.headlineLarge),
                Text(
                  'Her küçük adım, ilerlemenin ve sessiz büyümenin bir parçası.',
                  style: AppTypography.bodySmall,
                ),

                const SizedBox(height: 16),

                // Kutlama Şeridi (Milestone Unlock)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondaryContainer,
                        AppColors.surfaceContainerHigh,
                        AppColors.surfaceContainer,
                      ],
                    ),
                    borderRadius: AppRadius.xlRadius,
                    border: Border.all(
                      color: AppColors.tertiary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.tertiaryContainer.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: AppColors.tertiary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'YENİ KAZANIM',
                                  style: AppTypography.labelCaps,
                                ),
                                const SizedBox(width: 4),
                                const Text('✨', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Text(
                              '30 Günlük İstikrar',
                              style: AppTypography.headlineSmall.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Rozet vitrinine eklendi. Büyümen kök salıyor.',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2x2 KPI Matrisi
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    _buildKpiCard(
                      label: 'TOPLAM BAŞARI',
                      value: '${state.totalCompletions}',
                      subLabel: 'tamam',
                      trendText: '+12 bu hafta',
                      trendIcon: Icons.trending_up,
                      icon: Icons.task_alt,
                      iconColor: AppColors.primary,
                    ),
                    _buildKpiCard(
                      label: 'MEVCUT SERİ',
                      value: '${state.currentStreak}',
                      subLabel: 'gün',
                      trendText: '10.000 Adım ile',
                      icon: Icons.local_fire_department,
                      iconColor: AppColors.primaryFixed,
                    ),
                    _buildKpiCard(
                      label: 'EN UZUN SERİ',
                      value: '${state.longestStreak}',
                      subLabel: 'gün',
                      trendText: 'Tarihsel en iyi',
                      icon: Icons.emoji_events,
                      iconColor: AppColors.secondary,
                    ),
                    _buildKpiCard(
                      label: 'İSTİKRAR',
                      value: '%${(state.consistencyRate * 100).round()}',
                      subLabel: 'ritim',
                      trendText: 'Aylık ortalama',
                      trendIcon: Icons.check,
                      icon: Icons.donut_large,
                      iconColor: AppColors.tertiary,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Haftalık Aktivite Çubuk Grafiği
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: AppRadius.xlRadius,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Haftalık Aktivite',
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Tamamlanan alışkanlık dağılımı',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                          // Hafta / Ay Toggle
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: AppRadius.fullRadius,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => cubit.toggleTimeMode(true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: state.isWeeklyMode
                                          ? AppColors.primaryContainer
                                          : Colors.transparent,
                                      borderRadius: AppRadius.fullRadius,
                                    ),
                                    child: Text(
                                      'Hafta',
                                      style: AppTypography.caption.copyWith(
                                        color: state.isWeeklyMode
                                            ? AppColors.onPrimaryContainer
                                            : AppColors.outline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => cubit.toggleTimeMode(false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !state.isWeeklyMode
                                          ? AppColors.primaryContainer
                                          : Colors.transparent,
                                      borderRadius: AppRadius.fullRadius,
                                    ),
                                    child: Text(
                                      'Ay',
                                      style: AppTypography.caption.copyWith(
                                        color: !state.isWeeklyMode
                                            ? AppColors.onPrimaryContainer
                                            : AppColors.outline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Çubuk Grafiği (7 Gün)
                      SizedBox(
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar('Pzt', state.weeklyActivity[0], 5),
                            _buildBar(
                              'Sal',
                              state.weeklyActivity[1],
                              5,
                              isHighlighted: true,
                            ),
                            _buildBar('Çar', state.weeklyActivity[2], 5),
                            _buildBar('Per', state.weeklyActivity[3], 5),
                            _buildBar(
                              'Cum',
                              state.weeklyActivity[4],
                              5,
                              isHighlighted: true,
                            ),
                            _buildBar('Cmt', state.weeklyActivity[5], 5),
                            _buildBar(
                              'Paz',
                              state.weeklyActivity[6],
                              5,
                              isToday: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.energy_savings_leaf,
                            color: AppColors.tertiary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Bu hafta hedeflerinin %82\'sini gerçekleştirdin. Harika bir denge!',
                              style: AppTypography.caption,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Alışkanlık Karnen (Son 30 Gün)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alışkanlık Karnen',
                      style: AppTypography.headlineSmall.copyWith(fontSize: 16),
                    ),
                    Text('Son 30 Gün', style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: 10),
                _buildReportItem(
                  'Günde 10.000 Adım',
                  '30 Gün Kesintisiz Seri',
                  1.0,
                  Icons.directions_walk,
                  AppColors.tertiary,
                ),
                _buildReportItem(
                  'Sigarasız Yaşam',
                  '14 Günlük Temiz Yol',
                  0.78,
                  Icons.smoke_free,
                  AppColors.secondary,
                ),
                _buildReportItem(
                  'Günde 3 Litre Su',
                  'Karışık Ritim',
                  0.72,
                  Icons.water_drop,
                  AppColors.primary,
                ),
                _buildReportItem(
                  'Her Gün 100 Sayfa Oku',
                  '2. Günlük İlerleme',
                  0.65,
                  Icons.menu_book,
                  AppColors.secondaryFixedDim,
                ),
                _buildReportItem(
                  'Spor Salonuna Git',
                  'Henüz Başlanmadı',
                  0.04,
                  Icons.fitness_center,
                  AppColors.outline,
                ),

                const SizedBox(height: 20),

                // Niteliksel Gelişim Bento Kartları
                _buildInsightCard(
                  title: 'EN İSTİKRARLI ALIŞKANLIĞIN',
                  habitName: 'Günde 10.000 Adım',
                  description: 'Mükemmel bir istikrar! 30 gündür aralıksız sürdürüyorsun; bedenin ve zihnin bu ritmi benimsedi.',
                  icon: Icons.auto_awesome,
                  color: AppColors.tertiary,
                ),
                const SizedBox(height: 10),
                _buildInsightCard(
                  title: 'BİR SONRAKİ KÜÇÜK ADIMIN',
                  habitName: 'Spor Salonuna Git',
                  description: 'Bu hafta spor için sadece 10 dakikalık hafif bir başlangıç planlayabilirsin. İlk kıvılcım en değerlisidir.',
                  icon: Icons.directions_run,
                  color: AppColors.secondary,
                ),

                const SizedBox(height: 22),

                // Başarı Rozetleri Vitrini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Başarı Rozetleri',
                          style: AppTypography.headlineSmall.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Ruhuna ve disiplinine kazandırdıkların',
                          style: AppTypography.caption,
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
                        '${state.unlockedBadgesCount} / ${state.achievements.length} Kazanıldı',
                        style: AppTypography.labelCaps.copyWith(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4 Sütunlu Rozet Izgarası
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: state.achievements.length,
                  itemBuilder: (context, index) {
                    final badge = state.achievements[index];
                    return _buildBadgeTile(badge);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required String subLabel,
    required String trendText,
    IconData? trendIcon,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.labelCaps.copyWith(fontSize: 10),
              ),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.labelNumeric.copyWith(
                  fontSize: 22,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(subLabel, style: AppTypography.caption),
            ],
          ),
          Row(
            children: [
              if (trendIcon != null) ...[
                Icon(trendIcon, size: 12, color: AppColors.tertiary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  trendText,
                  style: AppTypography.caption.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    String day,
    double value,
    double maxVal, {
    bool isHighlighted = false,
    bool isToday = false,
  }) {
    final heightFactor = (value / maxVal).clamp(0.1, 1.0);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            isToday ? '${value.toInt()}/5' : '${value.toInt()}',
            style: AppTypography.caption.copyWith(
              fontSize: 10,
              color: isToday ? AppColors.tertiary : AppColors.outline,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 14,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppRadius.fullRadius,
            ),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70 * heightFactor,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.tertiary
                    : (isToday
                          ? AppColors.tertiaryContainer
                          : AppColors.primaryContainer),
                borderRadius: AppRadius.fullRadius,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            day,
            style: AppTypography.labelCaps.copyWith(
              fontSize: 10,
              color: isToday || isHighlighted
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
              fontWeight: isToday || isHighlighted
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(
    String title,
    String subtitle,
    double ratio,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.lgRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                '%${(ratio * 100).round()}',
                style: AppTypography.labelNumeric.copyWith(
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: AppRadius.fullRadius,
            child: Container(
              height: 5,
              color: AppColors.surfaceContainerHigh,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: ratio,
                child: Container(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String habitName,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelCaps.copyWith(
                    color: color,
                    fontSize: 10,
                  ),
                ),
                Text(
                  habitName,
                  style: AppTypography.headlineSmall.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeTile(Achievement badge) {
    final isUnlocked = badge.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.surfaceContainer
            : AppColors.surfaceContainerLowest.withValues(alpha: 0.5),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isUnlocked
              ? AppColors.tertiary.withValues(alpha: 0.25)
              : AppColors.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? AppColors.tertiaryContainer.withValues(alpha: 0.35)
                  : AppColors.surfaceContainerHigh,
            ),
            child: Icon(
              isUnlocked ? badge.icon : Icons.lock,
              color: isUnlocked ? AppColors.tertiary : AppColors.outline,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.title,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? AppColors.onSurface : AppColors.outline,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            isUnlocked ? 'Kazanıldı' : badge.requirementText,
            style: AppTypography.caption.copyWith(
              fontSize: 9,
              color: isUnlocked ? AppColors.tertiary : AppColors.outline,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
