import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

class WaterTrackerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int consumedWaterMl;
  final int dailyGoalWaterMl;
  final VoidCallback? onAddWater;

  const WaterTrackerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.consumedWaterMl,
    required this.dailyGoalWaterMl,
    this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: AppColors.neonCyan),
                const SizedBox(width: 8),
                Text(title, style: context.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: context.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              'Tüketilen: $consumedWaterMl ml / Hedef: $dailyGoalWaterMl ml',
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.neonCyan),
            ),
            if (onAddWater != null) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: onAddWater,
                icon: const Icon(Icons.add),
                label: const Text('+250 ml Ekle'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
