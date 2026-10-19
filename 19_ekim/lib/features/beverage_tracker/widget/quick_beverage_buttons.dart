import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/beverage_type.dart';

class QuickBeverageButtonsWidget extends StatelessWidget {
  final BeverageType beverageType;
  final void Function(int amount, String label) onAdd;

  const QuickBeverageButtonsWidget({
    super.key,
    required this.beverageType,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: beverageType.presets
          .map((preset) => _buildButton(context, preset))
          .toList(),
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
              Icon(preset.icon, color: beverageType.color, size: 24),
              const SizedBox(height: 6),
              Text(
                '+${preset.amount}',
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: beverageType.color,
                ),
              ),
              Text(preset.label, style: context.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
