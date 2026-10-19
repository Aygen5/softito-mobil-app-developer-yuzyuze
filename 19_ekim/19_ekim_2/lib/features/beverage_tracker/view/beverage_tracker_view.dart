import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../water_tracker/widget/water_progress_indicator.dart';
import '../controller/beverage_tracker_controller.dart';
import '../widget/beverage_breakdown_card.dart';
import '../widget/beverage_log_history_list.dart';
import '../widget/beverage_type_selector.dart';
import '../widget/quick_beverage_buttons.dart';

class BeverageTrackerView extends StatelessWidget {
  final BeverageTrackerController controller;
  final ThemeController? themeController;

  const BeverageTrackerView({
    super.key,
    required this.controller,
    this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WaterProgressIndicatorWidget(
                  progress: controller.progressRatio,
                  consumedMl: controller.effectiveHydrationMl,
                  goalMl: controller.dailyGoalMl,
                ),
                const SizedBox(height: 20),
                BeverageBreakdownCardWidget(
                  breakdown: controller.consumptionByType,
                  totalEffectiveHydration: controller.effectiveHydrationMl,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(context, 'İçecek Türü'),
                const SizedBox(height: 8),
                BeverageTypeSelectorWidget(
                  selectedType: controller.selectedType,
                  onSelected: controller.selectType,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle(
                  context,
                  '${controller.selectedType.label} Hızlı Ekle',
                ),
                const SizedBox(height: 8),
                QuickBeverageButtonsWidget(
                  beverageType: controller.selectedType,
                  onAdd: (amount, label) => controller.addBeverage(
                    controller.selectedType,
                    amount,
                    label,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Bugünün Geçmişi'),
                const SizedBox(height: 12),
                BeverageLogHistoryListWidget(
                  logs: controller.logs,
                  onDelete: controller.removeLog,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final isDark = themeController?.isDarkMode ?? true;
    return AppBar(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Su & İçecek Takibi'),
        ],
      ),
      actions: [
        if (themeController != null)
          IconButton(
            tooltip: isDark ? 'Açık Moda Geç' : 'Karanlık Moda Geç',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? AppColors.neonLime : AppColors.neonCyanDark,
            ),
            onPressed: themeController!.toggleTheme,
          ),
        IconButton(
          tooltip: 'Günü Sıfırla',
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
          onPressed: controller.resetToday,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(fontSize: 16),
    );
  }
}
