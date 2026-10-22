import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';

class HydrationCard extends StatelessWidget {
  final double currentMl;
  final double targetMl;
  final VoidCallback onAddWater;

  const HydrationCard({
    super.key,
    required this.currentMl,
    required this.targetMl,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final currentLitre = (currentMl / 1000)
        .toStringAsFixed(1)
        .replaceAll('.', ',');
    final targetLitre = (targetMl / 1000)
        .toStringAsFixed(1)
        .replaceAll('.', ',');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Su Damlası İkon Kutusu
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
              borderRadius: AppRadius.mdRadius,
            ),
            child: const Icon(
              Icons.water_drop,
              color: AppColors.tertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Bilgi Metinleri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hidrasyon Günlüğü',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(color: AppColors.outline, fontSize: 10),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$currentLitre / $targetLitre Litre',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Hedefine çok yaklaştın!',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  'Bir sonraki su molanı vermeyi unutma.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Su Ekle Butonu
          IconButton(
            onPressed: onAddWater,
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.tertiary,
              size: 28,
            ),
            tooltip: '+250 ml Ekle',
          ),
        ],
      ),
    );
  }
}
