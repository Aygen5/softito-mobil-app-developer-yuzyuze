import 'package:flutter/material.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/theme/app_colors.dart';

class RentalPriceSummary extends StatelessWidget {
  final double dailyPrice;
  final double hourlyPrice;
  final DateTime startDateTime;
  final DateTime endDateTime;

  const RentalPriceSummary({
    super.key,
    required this.dailyPrice,
    required this.hourlyPrice,
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final calculation = AppPriceUtils.calculateRentalPrice(
      dailyPrice: dailyPrice,
      hourlyPrice: hourlyPrice,
      start: startDateTime,
      end: endDateTime,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fiyat Özeti',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${calculation.days} Gün ${calculation.hours > 0 ? '${calculation.hours} Saat' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Günlük Taban Ücret
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppPriceUtils.formatPrice(dailyPrice)} x ${calculation.days} Gün',
                style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
              ),
              Text(
                AppPriceUtils.formatPrice(dailyPrice * calculation.days),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (calculation.hours > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ekstra ${calculation.hours} Saat (${AppPriceUtils.formatHourlyPrice(hourlyPrice)})',
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  AppPriceUtils.formatPrice(calculation.hours * hourlyPrice),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
          if (calculation.isDiscountApplied) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.discount_rounded, size: 14, color: AppColors.successGreen),
                    SizedBox(width: 4),
                    Text(
                      'Uzun Dönem İndirimi (%15)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
                Text(
                  '-${AppPriceUtils.formatPrice(calculation.discountAmount)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 20),
          // Toplam Ücret
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Tutar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              Text(
                AppPriceUtils.formatPrice(calculation.totalPrice),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
