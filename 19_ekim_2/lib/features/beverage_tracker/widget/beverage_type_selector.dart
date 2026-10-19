import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: BeverageType.values.map((type) {
          final isSelected = type == selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChoiceChip(type, isSelected),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChoiceChip(BeverageType type, bool isSelected) {
    return FilterChip(
      selected: isSelected,
      label: Text(type.label),
      avatar: Icon(
        type.icon,
        size: 18,
        color: isSelected ? AppColors.background : type.color,
      ),
      selectedColor: type.color,
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: isSelected ? type.color : AppColors.outline,
        width: 1.2,
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.background : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
      checkmarkColor: AppColors.background,
      onSelected: (_) => onSelected(type),
    );
  }
}
