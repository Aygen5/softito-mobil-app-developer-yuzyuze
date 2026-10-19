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
      children: beverageType.presets.map((preset) {
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
            Icon(icon, color: beverageType.color, size: 22),
            const SizedBox(height: 6),
            Text(
              '+$amount ml',
              style: context.textTheme.labelSmall?.copyWith(
                color: beverageType.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
