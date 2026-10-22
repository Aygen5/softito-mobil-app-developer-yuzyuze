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
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _openProfileModal(context),
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
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () =>
                            _openNotificationsModal(context, state.habits),
                        child: Stack(
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
                      ),
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

                // Hidrasyon Kartı (Tıklanınca & + Butonuna Basılınca Modal Açılır)
                HydrationCard(
                  currentMl: state.waterConsumed,
                  targetMl: state.waterTarget,
                  onAddWater: (amount) => cubit.addWater(amount),
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
                      onStart: () => cubit.startHabit(habit.id),
                      onAddProgress: habit.id == 'read_100p'
                          ? () => _openAddPageModal(context, cubit, habit)
                          : habit.id == 'water_3l'
                          ? () => _openWaterModal(context, cubit)
                          : habit.targetUnit != 'Gün' &&
                                habit.targetUnit != 'Hafta'
                          ? () => _openAddPageModal(context, cubit, habit)
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

  void _openNotificationsModal(BuildContext context, List<Habit> habits) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NotificationsSheet(habits: habits),
    );
  }

  void _openProfileModal(BuildContext context) {
    showProfileModal(context);
  }

  void _openAddPageModal(BuildContext context, HomeCubit cubit, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddPageSheet(
        habit: habit,
        onAddPages: (pages) => cubit.addReadPages(pages),
      ),
    );
  }

  void _openWaterModal(BuildContext context, HomeCubit cubit) {
    cubit.addWaterGlass();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.water_drop, color: AppColors.tertiary, size: 20),
            SizedBox(width: 8),
            Text('1 bardak su eklendi (+250 ml)! 💧'),
          ],
        ),
        backgroundColor: AppColors.surfaceContainerHigh,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _NotificationsSheet extends StatefulWidget {
  final List<Habit> habits;

  const _NotificationsSheet({required this.habits});

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  late final List<Map<String, dynamic>> _reminders;

  @override
  void initState() {
    super.initState();
    _reminders = [
      {
        'time': '08:30',
        'title': 'Günaydın Ritüeli',
        'desc': 'Zihnini güne ve alışkanlıklarına hazırla. Derin bir nefes al.',
        'icon': Icons.wb_sunny,
        'color': AppColors.primary,
        'enabled': true,
      },
      {
        'time': '09:00',
        'title': 'Sigarasız Yaşam',
        'desc': 'Sabah kahvesinde temiz nefesini kutla. 14 gündür harikasın!',
        'icon': Icons.smoke_free,
        'color': AppColors.secondary,
        'enabled': true,
      },
      {
        'time': '11:00',
        'title': 'Günde 3 Litre Su',
        'desc': 'Hidrasyon vakti! Bedenini tazelemek için büyük bir bardak su iç.',
        'icon': Icons.water_drop,
        'color': AppColors.tertiary,
        'enabled': true,
      },
      {
        'time': '14:00',
        'title': 'Öğle Farkındalık Molası',
        'desc': 'Omurganı dikleştir, gözlerini dinlendir ve ritmini yakala.',
        'icon': Icons.self_improvement,
        'color': AppColors.primaryFixedDim,
        'enabled': true,
      },
      {
        'time': '18:00',
        'title': 'Günde 10.000 Adım',
        'desc': 'Akşam yürüyüşü zamanı. Adım hedefine yaklaş!',
        'icon': Icons.directions_walk,
        'color': AppColors.tertiary,
        'enabled': true,
      },
      {
        'time': '19:00',
        'title': 'Spor Salonuna Git',
        'desc': 'Antrenman çantanı hazırla ve enerjini yükselt.',
        'icon': Icons.fitness_center,
        'color': AppColors.outline,
        'enabled': true,
      },
      {
        'time': '21:30',
        'title': 'Her Gün 100 Sayfa Oku',
        'desc': 'Günün yorgunluğunu sayfaların bilgeliğiyle geride bırak.',
        'icon': Icons.menu_book,
        'color': AppColors.secondaryFixedDim,
        'enabled': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sürükleme Çizgisi
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: AppRadius.fullRadius,
              ),
            ),
          ),

          // Başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.35),
                    borderRadius: AppRadius.mdRadius,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: AppColors.tertiary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hatırlatıcılar & Bildirimler',
                        style: AppTypography.headlineSmall.copyWith(fontSize: 17),
                      ),
                      Text(
                        'Zaman sırasına göre günlük bildirim akışı',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.fullRadius,
                  ),
                  child: Text(
                    '${_reminders.where((r) => r['enabled'] as bool).length} Aktif',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.outlineVariant, height: 1),

          // Hatırlatıcılar Listesi
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _reminders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = _reminders[index];
                final isEnabled = r['enabled'] as bool;
                final color = r['color'] as Color;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.surfaceContainerHigh
                        : AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.lgRadius,
                    border: Border.all(
                      color: isEnabled
                          ? color.withValues(alpha: 0.3)
                          : AppColors.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Saat Rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: AppRadius.smRadius,
                        ),
                        child: Text(
                          r['time'] as String,
                          style: AppTypography.labelNumeric.copyWith(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // İkon
                      Icon(r['icon'] as IconData, color: color, size: 20),
                      const SizedBox(width: 10),

                      // Detay
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r['title'] as String,
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isEnabled
                                    ? AppColors.onSurface
                                    : AppColors.outline,
                              ),
                            ),
                            Text(
                              r['desc'] as String,
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                color: isEnabled
                                    ? AppColors.onSurfaceVariant
                                    : AppColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Anahtar
                      Switch.adaptive(
                        value: isEnabled,
                        activeColor: AppColors.tertiary,
                        onChanged: (val) {
                          setState(() {
                            r['enabled'] = val;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class _AddPageSheet extends StatefulWidget {
  final Habit habit;
  final Function(double pages) onAddPages;

  const _AddPageSheet({required this.habit, required this.onAddPages});

  @override
  State<_AddPageSheet> createState() => _AddPageSheetState();
}

class _AddPageSheetState extends State<_AddPageSheet> {
  final _controller = TextEditingController(text: '15');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(double count) {
    widget.onAddPages(count);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.menu_book, color: AppColors.secondary, size: 20),
            const SizedBox(width: 8),
            Text('+${count.toInt()} sayfa eklendi! 📚 Zihnin gelişiyor.'),
          ],
        ),
        backgroundColor: AppColors.surfaceContainerHigh,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sürükleme Çizgisi
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: AppRadius.fullRadius,
              ),
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: AppRadius.mdRadius,
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: AppColors.onSecondaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.title, style: AppTypography.headlineSmall),
                    Text(
                      '${habit.todayProgress.toInt()} / ${habit.targetValue.toInt()} sayfa tamamlandı',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            'Hızlı Sayfa Ekle',
            style: AppTypography.labelCaps.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _add(10),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  child: const Text('+10 Sayfa'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _add(25),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  child: const Text('+25 Sayfa'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _add(50),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdRadius,
                    ),
                  ),
                  child: const Text('+50 Sayfa'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Özel Sayfa Miktarı',
                    suffixText: 'sayfa',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdRadius,
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final pages = double.tryParse(_controller.text) ?? 15;
                  _add(pages);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdRadius,
                  ),
                ),
                child: const Text(
                  'Ekle',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

