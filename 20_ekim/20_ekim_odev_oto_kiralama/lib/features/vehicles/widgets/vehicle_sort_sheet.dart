import 'package:flutter/material.dart';

class VehicleSortSheet extends StatelessWidget {
  final String currentSort;
  final ValueChanged<String> onSortSelected;

  const VehicleSortSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  static const List<({String key, String title, IconData icon})> _sortOptions = [
    (key: 'price_asc', title: 'Fiyata Göre: En Düşük Fiyat (Artan)', icon: Icons.arrow_upward_rounded),
    (key: 'price_desc', title: 'Fiyata Göre: En Yüksek Fiyat (Azalan)', icon: Icons.arrow_downward_rounded),
    (key: 'year_desc', title: 'Model Yılı: En Yeni', icon: Icons.calendar_today_rounded),
    (key: 'year_asc', title: 'Model Yılı: En Eski', icon: Icons.history_rounded),
    (key: 'mileage_asc', title: 'Kilometre: En Düşük', icon: Icons.speed_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sıralama Seçenekleri',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            ..._sortOptions.map((opt) {
              final isSelected = currentSort == opt.key;
              return ListTile(
                leading: Icon(
                  opt.icon,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  opt.title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                    : null,
                onTap: () {
                  onSortSelected(opt.key);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
