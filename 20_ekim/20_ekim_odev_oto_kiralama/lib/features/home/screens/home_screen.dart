import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../data/vehicle_data_source.dart';
import '../../../models/vehicle.dart';
import '../widgets/category_list.dart';
import '../widgets/featured_vehicle_card.dart';
import '../widgets/branch_map_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final VehicleDataSource _dataSource = VehicleDataSource();

  String _selectedPickupLocation = AppConstants.pickupLocations[0];
  String _selectedReturnLocation = AppConstants.pickupLocations[0];
  DateTime _selectedStartDate = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 4));

  bool _isLoading = true;
  List<Vehicle> _featuredVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      await _dataSource.loadVehicles();
      if (mounted) {
        setState(() {
          _featuredVehicles = _dataSource.getFeaturedVehicles();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onCategorySelected(String category) {
    AppNavigation.toVehicleList(context, initialCategory: category);
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      AppNavigation.toVehicleList(context, initialSearchQuery: query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _dataSource.loadVehicles(forceReload: true);
            if (mounted) {
              setState(() {
                _featuredVehicles = _dataSource.getFeaturedVehicles();
              });
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst Başlık & Karşılama
                _buildHeader(theme, colorScheme),

                const SizedBox(height: 16),

                // Arama Kutusu
                _buildSearchBar(theme, colorScheme, isDark),

                const SizedBox(height: 18),

                // Hızlı Rezervasyon / Tarih & Konum Özeti Kartı
                _buildQuickRentalCard(theme, colorScheme, isDark),

                const SizedBox(height: 24),

                // Araç Kategorileri
                AppSectionTitle(
                  title: 'Araç Kategorileri',
                  subtitle: 'İhtiyacınıza uygun sınıfı seçin',
                  actionText: 'Tümü',
                  onActionTap: () => AppNavigation.toVehicleList(context),
                ),
                CategoryList(
                  onCategorySelected: _onCategorySelected,
                ),

                const SizedBox(height: 24),

                // Öne Çıkan Araçlar
                AppSectionTitle(
                  title: 'Öne Çıkan Araçlar',
                  subtitle: 'En çok tercih edilen popüler modeller',
                  actionText: 'Tüm Araçlar',
                  onActionTap: () => AppNavigation.toVehicleList(context),
                ),
                _buildFeaturedList(theme),

                const SizedBox(height: 24),

                // Temsili Şube Haritası
                AppSectionTitle(
                  title: 'Hizmet Noktalarımız',
                  subtitle: 'Türkiye geneli havalimanı ve şehir içi şubelerimiz',
                ),
                const BranchMapPreview(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E40AF).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.car_rental_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: -0.5,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Merhaba, ${AppConstants.demoUserName.split(' ')[0]} 👋',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Tema Değiştirme Butonu
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton.filledTonal(
                onPressed: () => themeController.toggleTheme(),
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  size: 20,
                ),
                tooltip: isDark ? 'Açık Temaya Geç' : 'Koyu Temaya Geç',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Araç markası, modeli veya kategorisi arayın...',
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  onPressed: () => AppNavigation.toVehicleList(context),
                ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildQuickRentalCard(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Hızlı Kiralama Planla',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Alış & Dönüş Noktası
          Row(
            children: [
              Expanded(
                child: _buildLocationSelector(
                  title: 'Alış Noktası',
                  value: _selectedPickupLocation,
                  icon: Icons.trip_origin_rounded,
                  colorScheme: colorScheme,
                  onTap: () => _selectLocation(isPickup: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLocationSelector(
                  title: 'Dönüş Noktası',
                  value: _selectedReturnLocation,
                  icon: Icons.place_rounded,
                  colorScheme: colorScheme,
                  onTap: () => _selectLocation(isPickup: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Tarih Seçimi Özeti
          InkWell(
            onTap: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                initialDateRange: DateTimeRange(start: _selectedStartDate, end: _selectedEndDate),
              );
              if (range != null) {
                setState(() {
                  _selectedStartDate = range.start;
                  _selectedEndDate = range.end;
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppDateUtils.formatDate(_selectedStartDate)} - ${AppDateUtils.formatDate(_selectedEndDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedEndDate.difference(_selectedStartDate).inDays} Gün',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Araçları Bul Butonu
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                AppNavigation.toVehicleList(context);
              },
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('Müsait Araçları Listele'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector({
    required String title,
    required String value,
    required IconData icon,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: colorScheme.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value.split(' - ').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocation({required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  isPickup ? 'Alış Noktası Seçin' : 'Dönüş Noktası Seçin',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConstants.pickupLocations.length,
                  itemBuilder: (context, index) {
                    final loc = AppConstants.pickupLocations[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(loc),
                      onTap: () {
                        setState(() {
                          if (isPickup) {
                            _selectedPickupLocation = loc;
                          } else {
                            _selectedReturnLocation = loc;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturedList(ThemeData theme) {
    if (_isLoading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_featuredVehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 310,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _featuredVehicles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final vehicle = _featuredVehicles[index];
          return FeaturedVehicleCard(
            vehicle: vehicle,
            onTap: () => AppNavigation.toVehicleDetail(context, vehicle: vehicle),
          );
        },
      ),
    );
  }
}
