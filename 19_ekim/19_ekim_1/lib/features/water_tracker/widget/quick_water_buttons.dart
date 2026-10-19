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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _presets.map((preset) => _buildButton(context, preset)).toList(),
    );
  }

  Widget _buildButton(
    BuildContext context,
    ({int amount, String label, IconData icon}) preset,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onAdd(preset.amount, preset.label),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(preset.icon, color: AppColors.neonCyan, size: 24),
              const SizedBox(height: 6),
              Text(
                '+${preset.amount}',
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonCyan,
                ),
              ),
              Text(
                preset.label,
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
