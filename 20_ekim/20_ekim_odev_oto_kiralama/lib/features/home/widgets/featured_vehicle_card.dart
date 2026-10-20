import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_utils.dart';

/// ---------------------------------------------------------------------------
/// 🏎️ FeaturedVehicleCard — Öne Çıkan Araç Vitrin Kartı
/// ---------------------------------------------------------------------------
/// Ana sayfada yatay şeritte gösterilen, geniş görselli, kategori ve yıl rozetli
/// premium kart bileşenidir.
class FeaturedVehicleCard extends StatelessWidget {
  final Vehicle vehicle;    // Gösterilecek araç modeli
  final VoidCallback onTap; // Karta dokunulduğunda çalışacak tıklama fonksiyonu

  const FeaturedVehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(vehicle.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(isDark ? 0.4 : 0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        /// 'Clip.antiAlias':
        /// Kartın köşeleri yuvarlatıldığı için içindeki köşeli fotoğrafın
        /// kenarlardan taşmasını engeller ve pürüzsüz biçimde keser (Maskeleme).
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // 📸 1. Görsel ve Rozetler Bölümü (Stack & Positioned)
            // -----------------------------------------------------------------
            /// 'Stack': İçindeki widget'ları birbiri üzerine bindirmeye (katman katman) yarar.
            Stack(
              children: [
                // Araç Görseli
                Container(
                  height: 150,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  child: Image.network(
                    vehicle.image,
                    fit: BoxFit.cover,
                    /// 'errorBuilder':
                    /// İnternet bağlantısı kesildiğinde veya görsel URL'si bozulduğunda
                    /// uygulamanın çökmesini önler ve yerine şık yedek ikon çizer.
                    errorBuilder: (_, __, ___) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_filled_rounded,
                              size: 48,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vehicle.brand,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Sol Üst: Renkli Kategori Rozeti
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: catColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      vehicle.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                // Sağ Üst: Yarı Saydam Siyah Model Yılı Rozeti
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

            // -----------------------------------------------------------------
            // 📄 2. Araç Bilgi ve Fiyat Alanı
            // -----------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marka
                  Text(
                    vehicle.brand,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Model
                  Text(
                    vehicle.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Vites ve Yakıt Özellik Çipleri
                  Row(
                    children: [
                      _buildChip(
                        theme,
                        Icons.settings_suggest_rounded,
                        vehicle.transmission,
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        theme,
                        Icons.local_gas_station_rounded,
                        vehicle.fuelType,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Günlük Ücret ve 'Kirala' Eylem Düğmesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Günlük',
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            AppPriceUtils.formatPrice(vehicle.dailyPrice),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Kirala',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
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

  /// Küçük teknik özellik çipi (Vites, Yakıt)
  Widget _buildChip(ThemeData theme, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
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

