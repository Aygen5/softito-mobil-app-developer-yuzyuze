import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final VoidCallback onNextQuote;

  const QuoteCard({super.key, required this.quote, required this.onNextQuote});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNextQuote,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.format_quote,
              color: AppColors.primaryFixedDim,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote,
                    style: AppTypography.headlineSmall.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 2,
                        color: AppColors.secondaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GÜNÜN İLHAMI',
                        style: AppTypography.labelCaps.copyWith(
                          fontSize: 10,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.refresh,
                        color: AppColors.outline,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
