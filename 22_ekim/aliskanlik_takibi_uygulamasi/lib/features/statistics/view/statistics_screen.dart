import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/achievement.dart';
import '../../habits/view/habit_form_sheet.dart';
import '../../profile/view/profile_modal_sheet.dart';
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

                // Aktivite Çubuk Grafiği (Haftalık / Aylık Dinamik)
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
                                state.isWeeklyMode
                                    ? 'Haftalık Aktivite'
                                    : 'Aylık Aktivite',
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                state.isWeeklyMode
                                    ? 'Tamamlanan alışkanlık dağılımı (7 Gün)'
                                    : 'Haftalık dağılım (4 Hafta)',
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
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => cubit.toggleTimeMode(true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
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
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => cubit.toggleTimeMode(false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Dinamik Çubuk Grafiği (Haftalık: 7 Gün, Aylık: 4 Hafta)
                      SizedBox(
                        height: 125,
                        child: state.isWeeklyMode
                            ? Row(
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
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar(
                                    '1. Hf',
                                    state.monthlyActivity[0],
                                    35,
                                  ),
                                  _buildBar(
                                    '2. Hf',
                                    state.monthlyActivity[1],
                                    35,
                                    isHighlighted: true,
                                  ),
                                  _buildBar(
                                    '3. Hf',
                                    state.monthlyActivity[2],
                                    35,
                                  ),
                                  _buildBar(
                                    '4. Hf',
                                    state.monthlyActivity[3],
                                    35,
                                    isToday: true,
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 14),
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
                              state.isWeeklyMode
                                  ? 'Bu hafta hedeflerinin %82\'sini gerçekleştirdin. Harika bir denge!'
                                  : 'Bu ay toplam ${(state.monthlyActivity.fold(0.0, (a, b) => a + b)).toInt()} alışkanlık tamamladın. İstikrarlı bir büyüme!',
                              style: AppTypography.caption,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Alışkanlık Karnen (Tek Kart, Tıklanınca Açılan Hareketli Liste)
                const _ExpandableReportCard(),

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
                    return _InteractiveBadgeTile(badge: badge);
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
}

class _ExpandableReportCard extends StatefulWidget {
  const _ExpandableReportCard();

  @override
  State<_ExpandableReportCard> createState() => _ExpandableReportCardState();
}

class _ExpandableReportCardState extends State<_ExpandableReportCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: _isExpanded
              ? AppColors.tertiary.withValues(alpha: 0.5)
              : AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tıklanabilir Başlık
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: AppRadius.xlRadius,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer.withValues(
                          alpha: 0.35,
                        ),
                        borderRadius: AppRadius.mdRadius,
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in,
                        color: AppColors.tertiary,
                        size: 24,
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
                                'Alışkanlık Karnen',
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.tertiaryContainer,
                                  borderRadius: AppRadius.fullRadius,
                                ),
                                child: Text(
                                  '5 Alışkanlık',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10,
                                    color: AppColors.onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isExpanded
                                ? 'Kapatmak için dokun'
                                : 'Son 30 günlük başarı karneni açmak için dokun',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Açılan 5 Alışkanlık Listesi (Akordeon Animasyonu)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(
                          color: AppColors.outlineVariant,
                          height: 1,
                        ),
                        const SizedBox(height: 12),
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
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
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
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: AppRadius.fullRadius,
            child: Container(
              height: 5,
              color: AppColors.surfaceContainerLowest,
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
}

class _InteractiveBadgeTile extends StatefulWidget {
  final Achievement badge;

  const _InteractiveBadgeTile({required this.badge});

  @override
  State<_InteractiveBadgeTile> createState() => _InteractiveBadgeTileState();
}

class _InteractiveBadgeTileState extends State<_InteractiveBadgeTile> {
  bool _isHovered = false;

  void _showBadgeDetail(BuildContext context) {
    final badge = widget.badge;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.isUnlocked
                    ? AppColors.tertiaryContainer
                    : AppColors.surfaceContainerHigh,
                boxShadow: badge.isUnlocked
                    ? [
                        BoxShadow(
                          color: AppColors.tertiary.withValues(alpha: 0.6),
                          blurRadius: 14,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                badge.isUnlocked ? badge.icon : Icons.lock,
                color: badge.isUnlocked
                    ? AppColors.tertiary
                    : AppColors.outline,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(badge.title, style: AppTypography.headlineSmall),
                  Text(
                    badge.isUnlocked ? 'Kazanıldı • Başarı' : 'Kilitli Rozet',
                    style: AppTypography.caption.copyWith(
                      color: badge.isUnlocked
                          ? AppColors.tertiary
                          : AppColors.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description, style: AppTypography.bodyMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: AppRadius.mdRadius,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gereksinim: ${badge.requirementText}',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Kapat',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badge = widget.badge;
    final isUnlocked = badge.isUnlocked;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showBadgeDetail(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isHovered ? -7 : 0, 0)
            ..scale(_isHovered ? 1.04 : 1.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _isHovered
                          ? AppColors.tertiaryContainer.withValues(alpha: 0.5)
                          : AppColors.surfaceContainer,
                      AppColors.surfaceContainerHigh,
                    ],
                  )
                : null,
            color: isUnlocked
                ? null
                : (_isHovered
                    ? AppColors.surfaceContainerHigh
                    : AppColors.surfaceContainerLowest.withValues(alpha: 0.5)),
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: isUnlocked
                  ? (_isHovered
                      ? AppColors.tertiary
                      : AppColors.tertiary.withValues(alpha: 0.35))
                  : (_isHovered
                      ? AppColors.outline
                      : AppColors.outlineVariant.withValues(alpha: 0.2)),
              width: _isHovered ? 1.6 : 1.0,
            ),
            boxShadow: [
              if (isUnlocked && _isHovered) ...[
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.65),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ] else if (_isHovered) ...[
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? (_isHovered
                          ? AppColors.tertiary
                          : AppColors.tertiaryContainer.withValues(alpha: 0.35))
                      : AppColors.surfaceContainerHigh,
                  boxShadow: isUnlocked && _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.tertiary.withValues(alpha: 0.8),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isUnlocked ? badge.icon : Icons.lock,
                  color: isUnlocked
                      ? (_isHovered ? AppColors.onTertiary : AppColors.tertiary)
                      : AppColors.outline,
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
        ),
      ),
    );
  }
}
