import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/beverage_type.dart';

class BeverageTypeSelectorWidget extends StatelessWidget {
  final BeverageType selectedType;
  final ValueChanged<BeverageType> onSelected;

  const BeverageTypeSelectorWidget({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: BeverageType.values.map((type) {
        final isSelected = type == selectedType;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildItem(context, type, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItem(BuildContext context, BeverageType type, bool isSelected) {
    return InkWell(
      onTap: () => onSelected(type),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? type.color.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? type.color : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 20,
              color: isSelected ? type.color : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              type.label,
              style: context.textTheme.labelSmall?.copyWith(
                color: isSelected ? type.color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
