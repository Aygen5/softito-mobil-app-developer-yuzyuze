import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

/// ---------------------------------------------------------------------------
/// 🏷️ CategoryList — Yatay Kategori Seçim Listesi (Category Chips)
/// ---------------------------------------------------------------------------
/// Ana sayfada 'Basic', 'Flex', 'Lux', 'Ultra Lux' gibi araç sınıflarını
/// yatay kaydırılabilir şık kutular halinde gösterir.
///
/// 💫 'AnimatedContainer' Kullanımı:
/// Kullanıcı bir kategoriye dokunduğunda veya seçtiğinde, rengin ve gölgenin
/// aniden değil, 200 milisaniyelik mikro animasyonla yumuşak bir şekilde
/// değişmesini sağlar.
class CategoryList extends StatelessWidget {
  /// Şu an seçili olan kategori adı (örn: 'Lux'). Seçili olan renkli görünür.
  final String? selectedCategory;

  /// Kullanıcı bir kategoriye dokunduğunda tetiklenen fonksiyon
  final ValueChanged<String> onCategorySelected;

  const CategoryList({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  /// Kategori adına göre uygun ikon seçen yardımcı fonksiyon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Basic':
        return Icons.directions_car_rounded;
      case 'Basic+':
        return Icons.electric_car_rounded;
      case 'Flex':
        return Icons.commute_rounded;
      case 'Flex+':
        return Icons.airport_shuttle_rounded;
      case 'Lux':
        return Icons.sports_motorsports_rounded;
      case 'Ultra Lux':
        return Icons.diamond_rounded;
      default:
        return Icons.apps_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 104,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.vehicleCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = AppConstants.vehicleCategories[index];
          final isSelected = selectedCategory == category;
          final catColor = AppColors.getCategoryColor(category);

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 86,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                // Seçiliyse kategorinin canlı rengi, değilse yüzey rengi
                color: isSelected
                    ? catColor
                    : (isDark
                        ? theme.colorScheme.surfaceVariant
                        : theme.colorScheme.surface),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? catColor
                      : (isDark
                          ? theme.colorScheme.outline.withOpacity(0.3)
                          : theme.colorScheme.outline.withOpacity(0.6)),
                  width: isSelected ? 2 : 1,
                ),
                // Seçili olduğunda arkaya renkli ışıltı gölgesi ekle
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: catColor.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dairesel İkon Alanı
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : catColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      size: 22,
                      color: isSelected ? Colors.white : catColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Kategori Adı
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

