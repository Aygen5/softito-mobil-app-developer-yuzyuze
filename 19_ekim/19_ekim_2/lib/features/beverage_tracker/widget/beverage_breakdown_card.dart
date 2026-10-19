import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/beverage_type.dart';

class BeverageBreakdownCardWidget extends StatelessWidget {
  final Map<BeverageType, int> breakdown;
  final int totalEffectiveHydration;

  const BeverageBreakdownCardWidget({
    super.key,
    required this.breakdown,
    required this.totalEffectiveHydration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Günlük Sıvı Dağılımı',
                style: context.textTheme.titleLarge?.copyWith(fontSize: 15),
              ),
              Text(
                'Efektif: $totalEffectiveHydration ml',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: BeverageType.values.map((type) {
              final amount = breakdown[type] ?? 0;
              return Expanded(
                child: _buildBreakdownItem(context, type, amount),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(BuildContext context, BeverageType type, int amount) {
    return Column(
      children: [
        Icon(type.icon, color: type.color, size: 20),
        const SizedBox(height: 4),
        Text(
          '$amount',
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: type.color,
          ),
        ),
        Text(
          type.label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
