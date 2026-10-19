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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 12),
          _buildGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Günlük Sıvı Dağılımı',
          style: context.textTheme.titleLarge?.copyWith(fontSize: 15),
        ),
        Text(
          'Net: $totalEffectiveHydration ml',
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: BeverageType.values.map((type) {
        final amount = breakdown[type] ?? 0;
        return _buildBeverageStat(context, type, amount);
      }).toList(),
    );
  }

  Widget _buildBeverageStat(BuildContext context, BeverageType type, int amount) {
    return Column(
      children: [
        Icon(type.icon, size: 18, color: type.color),
        const SizedBox(height: 4),
        Text(
          '$amount',
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(type.label, style: context.textTheme.labelSmall),
      ],
    );
  }
}
