import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/water_tracker_controller.dart';
import '../widget/quick_water_buttons.dart';
import '../widget/water_log_history_list.dart';
import '../widget/water_progress_indicator.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
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
                  consumedMl: controller.consumedMl,
                  goalMl: controller.dailyGoalMl,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Hızlı Ekle'),
                const SizedBox(height: 12),
                QuickWaterButtonsWidget(
                  onAdd: (amount, label) => controller.addWater(amount, label),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Bugünün Geçmişi'),
                const SizedBox(height: 12),
                WaterLogHistoryListWidget(
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
    return AppBar(
      title: const Text('Su Takibi'),
      actions: [
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
