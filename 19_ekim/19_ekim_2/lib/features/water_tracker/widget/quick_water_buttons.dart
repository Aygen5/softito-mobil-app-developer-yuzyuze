import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';

class QuickWaterButtonsWidget extends StatelessWidget {
  final void Function(int amount, String label) onAdd;

  const QuickWaterButtonsWidget({
    super.key,
    required this.onAdd,
  });

  static const _presets = [
    (amount: 200, label: 'Bardak', icon: Icons.local_drink),
    (amount: 300, label: 'Kupa', icon: Icons.coffee),
    (amount: 500, label: 'Matara', icon: Icons.sports_gymnastics),
    (amount: 750, label: 'Şişe', icon: Icons.wine_bar_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _presets.map((preset) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildItem(context, preset.amount, preset.label, preset.icon),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItem(BuildContext context, int amount, String label, IconData icon) {
    return InkWell(
      onTap: () => onAdd(amount, label),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.neonCyan, size: 22),
            const SizedBox(height: 6),
            Text(
              '+$amount ml',
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
