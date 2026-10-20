import 'package:flutter/material.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/vehicle_data_source.dart';
import '../../../models/vehicle.dart';
import '../widgets/vehicle_grid.dart';
import '../widgets/vehicle_sort_sheet.dart';
import '../widgets/vehicle_filter_sheet.dart';

class VehicleListScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialSearchQuery;

  const VehicleListScreen({
    super.key,
    this.initialCategory,
    this.initialSearchQuery,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleDataSource _dataSource = VehicleDataSource();
  final TextEditingController _searchController = TextEditingController();

  int _columnCount = 1; // 1: Liste, 2: 2'li ızgara, 3: 3'lü kompakt
  String _currentSort = 'price_asc';

  String? _selectedCategory;
  String? _selectedTransmission;
  String? _selectedFuelType;
  RangeValues _priceRange = const RangeValues(1000.0, 10000.0);

  bool _isLoading = true;
  List<Vehicle> _filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    if (widget.initialSearchQuery != null) {
      _searchController.text = widget.initialSearchQuery!;
    }
    _loadAndFilter();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAndFilter() async {
    await _dataSource.loadVehicles();
    _applyFiltersAndSort();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFiltersAndSort() {
    final filtered = _dataSource.filterVehicles(
      category: _selectedCategory,
      transmission: _selectedTransmission,
      fuelType: _selectedFuelType,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      searchQuery: _searchController.text,
    );

    _filteredVehicles = _dataSource.sortVehicles(filtered, _currentSort);
  }

  bool get _hasActiveFilters =>
      _selectedCategory != null ||
      _selectedTransmission != null ||
      _selectedFuelType != null ||
      _priceRange.start > 1000.0 ||
      _priceRange.end < 10000.0;

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTransmission = null;
      _selectedFuelType = null;
      _priceRange = const RangeValues(1000.0, 10000.0);
      _searchController.clear();
      _applyFiltersAndSort();
    });
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => VehicleSortSheet(
        currentSort: _currentSort,
        onSortSelected: (sortKey) {
          setState(() {
            _currentSort = sortKey;
            _applyFiltersAndSort();
          });
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => VehicleFilterSheet(
        initialCategory: _selectedCategory,
        initialTransmission: _selectedTransmission,
        initialFuelType: _selectedFuelType,
        currentPriceRange: _priceRange,
        onApply: ({category, transmission, fuelType, priceRange}) {
          setState(() {
            _selectedCategory = category;
            _selectedTransmission = transmission;
            _selectedFuelType = fuelType;
            if (priceRange != null) {
              _priceRange = priceRange;
            }
            _applyFiltersAndSort();
          });
        },
        onReset: _resetFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiralık Araçlar'),
        actions: [
          // Görünüm Değiştirici (1, 2, 3 Sütun)
          IconButton(
            icon: Icon(
              _columnCount == 1
                  ? Icons.view_agenda_outlined
                  : (_columnCount == 2 ? Icons.grid_view_rounded : Icons.apps_rounded),
            ),
            tooltip: 'Görünüm Değiştir',
            onPressed: () {
              setState(() {
                _columnCount = (_columnCount % 3) + 1;
              });
            },
          ),
          // Sıralama Butonu
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sırala',
            onPressed: _showSortSheet,
          ),
          // Filtreleme Butonu
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Filtrele',
                onPressed: _showFilterSheet,
              ),
              if (_hasActiveFilters)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Arama Kutusu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Araç ara (Marka, model)...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _applyFiltersAndSort();
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onChanged: (_) {
                setState(() {
                  _applyFiltersAndSort();
                });
              },
            ),
          ),

          // Aktif Filtre Çipleri ve Sonuç Sayısı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredVehicles.length} araç listeleniyor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (_hasActiveFilters)
                  GestureDetector(
                    onTap: _resetFilters,
                    child: Text(
                      'Filtreleri Temizle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (_hasActiveFilters)
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_selectedCategory != null)
                    _buildActiveFilterChip('Kategori: $_selectedCategory', () {
                      setState(() {
                        _selectedCategory = null;
                        _applyFiltersAndSort();
                      });
                    }),
                  if (_selectedTransmission != null)
                    _buildActiveFilterChip('Vites: $_selectedTransmission', () {
                      setState(() {
                        _selectedTransmission = null;
                        _applyFiltersAndSort();
                      });
                    }),
                  if (_selectedFuelType != null)
                    _buildActiveFilterChip('Yakıt: $_selectedFuelType', () {
                      setState(() {
                        _selectedFuelType = null;
                        _applyFiltersAndSort();
                      });
                    }),
                ],
              ),
            ),

          const SizedBox(height: 6),

          // Araç Listesi Görünümü
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredVehicles.isEmpty
                    ? AppEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Sonuç Bulunamadı',
                        description: 'Arama kriterlerinize uyan araç bulunamadı. Filtreleri temizleyip tekrar deneyin.',
                        buttonText: 'Filtreleri Temizle',
                        onButtonPressed: _resetFilters,
                      )
                    : VehicleGrid(
                        vehicles: _filteredVehicles,
                        columnCount: _columnCount,
                        onVehicleTap: (vehicle) {
                          AppNavigation.toVehicleDetail(context, vehicle: vehicle);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        deleteIcon: const Icon(Icons.close_rounded, size: 14),
        onDeleted: onDeleted,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
