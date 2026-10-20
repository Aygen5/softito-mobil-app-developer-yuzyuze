import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_utils.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;
  final int columnCount; // 1: Liste, 2: İkili ızgara, 3: Üçlü kompakt ızgara

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
    this.columnCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (columnCount == 1) {
      return _buildSingleColumnCard(context);
    } else if (columnCount == 2) {
      return _buildTwoColumnCard(context);
    } else {
      return _buildThreeColumnCard(context);
    }
  }

  // 1 Sütun: Geniş Yatay/Dikey Detaylı Kart
  Widget _buildSingleColumnCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(vehicle.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  child: Image.network(
                    vehicle.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallback(theme),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      vehicle.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${vehicle.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // İçerik
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.brand,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            vehicle.model,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppPriceUtils.formatPrice(vehicle.dailyPrice),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            'günlük',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Özellik Rozetleri
                  Row(
                    children: [
                      _buildChip(theme, Icons.settings_suggest_rounded, vehicle.transmission),
                      const SizedBox(width: 8),
                      _buildChip(theme, Icons.local_gas_station_rounded, vehicle.fuelType),
                      const SizedBox(width: 8),
                      _buildChip(theme, Icons.speed_rounded, '${vehicle.mileage} km'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('İncele', style: TextStyle(fontSize: 12)),
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

  // 2 Sütun: Standart Grid Kartı
  Widget _buildTwoColumnCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(vehicle.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  child: Image.network(
                    vehicle.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallback(theme),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vehicle.category,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            // Metinler
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.brand,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    vehicle.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.transmission} • ${vehicle.fuelType}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppPriceUtils.formatPrice(vehicle.dailyPrice),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3 Sütun: Kompakt Grid Kartı
  Widget _buildThreeColumnCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: double.infinity,
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              child: Image.network(
                vehicle.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallback(theme, iconSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppPriceUtils.formatPrice(vehicle.dailyPrice),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback(ThemeData theme, {double iconSize = 40}) {
    return Center(
      child: Icon(
        Icons.directions_car_filled_rounded,
        size: iconSize,
        color: theme.colorScheme.primary.withOpacity(0.4),
      ),
    );
  }

  Widget _buildChip(ThemeData theme, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
