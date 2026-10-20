import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/widgets/app_button.dart';

class VehicleFilterSheet extends StatefulWidget {
  final String? initialCategory;
  final String? initialTransmission;
  final String? initialFuelType;
  final double minPrice;
  final double maxPrice;
  final RangeValues currentPriceRange;
  final Function({
    String? category,
    String? transmission,
    String? fuelType,
    RangeValues? priceRange,
  }) onApply;
  final VoidCallback onReset;

  const VehicleFilterSheet({
    super.key,
    this.initialCategory,
    this.initialTransmission,
    this.initialFuelType,
    this.minPrice = 1000.0,
    this.maxPrice = 10000.0,
    required this.currentPriceRange,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<VehicleFilterSheet> createState() => _VehicleFilterSheetState();
}

class _VehicleFilterSheetState extends State<VehicleFilterSheet> {
  late String? _selectedCategory;
  late String? _selectedTransmission;
  late String? _selectedFuelType;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedTransmission = widget.initialTransmission;
    _selectedFuelType = widget.initialFuelType;
    _priceRange = widget.currentPriceRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Başlık & Kapat Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtreler',
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
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori Filtresi
                    _buildSectionHeader('Araç Kategorisi'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.vehicleCategories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Vites Türü
                    _buildSectionHeader('Vites Türü'),
                    Wrap(
                      spacing: 8,
                      children: ['Otomatik', 'Manuel'].map((trans) {
                        final isSelected = _selectedTransmission == trans;
                        return ChoiceChip(
                          label: Text(trans),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedTransmission = selected ? trans : null;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Yakıt Türü
                    _buildSectionHeader('Yakıt Türü'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Benzin', 'Dizel', 'Hibrit', 'Elektrik'].map((fuel) {
                        final isSelected = _selectedFuelType == fuel;
                        return ChoiceChip(
                          label: Text(fuel),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFuelType = selected ? fuel : null;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Fiyat Aralığı
                    _buildSectionHeader('Günlük Fiyat Aralığı'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppPriceUtils.formatPrice(_priceRange.start),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          AppPriceUtils.formatPrice(_priceRange.end),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: widget.minPrice,
                      max: widget.maxPrice,
                      divisions: 30,
                      labels: RangeLabels(
                        AppPriceUtils.formatPrice(_priceRange.start),
                        AppPriceUtils.formatPrice(_priceRange.end),
                      ),
                      onChanged: (values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // Aksiyon Butonları
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      text: 'Filtreleri Temizle',
                      onPressed: () {
                        widget.onReset();
                        Navigator.pop(context);
                      },
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Uygula',
                      onPressed: () {
                        widget.onApply(
                          category: _selectedCategory,
                          transmission: _selectedTransmission,
                          fuelType: _selectedFuelType,
                          priceRange: _priceRange,
                        );
                        Navigator.pop(context);
                      },
                      height: 48,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
