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

/// ---------------------------------------------------------------------------
/// 🏠 HomeScreen — Ana Sayfa ve Keşif Vitrini
/// ---------------------------------------------------------------------------
/// Kullanıcının uygulamayı açtığında karşılaştığı ana vitrindir:
/// - Karşılama başlığı ve anlık açık/koyu tema değiştirme düğmesi
/// - Araç arama çubuğu
/// - Hızlı kiralama planlama kartı (alış/dönüş şubesi ve tarih seçici)
/// - Kategori filtreleme çipleri (Basic, Flex, Lux...)
/// - Yatay kaydırılabilir "Öne Çıkan Araçlar" vitrini
/// - Temsili Türkiye şube haritası önizlemesi
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Arama kutusundaki metni kontrol etmek için Controller
  final TextEditingController _searchController = TextEditingController();

  // Araç verilerini çeken Singleton servis
  final VehicleDataSource _dataSource = VehicleDataSource();

  // Hızlı Kiralama Formu Durumları (State)
  String _selectedPickupLocation = AppConstants.pickupLocations[0];
  String _selectedReturnLocation = AppConstants.pickupLocations[0];
  DateTime _selectedStartDate = DateTime.now().add(const Duration(days: 1)); // Yarın
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 4));   // 4 gün sonra

  bool _isLoading = true;
  List<Vehicle> _featuredVehicles = [];

  /// Sayfa açıldığında ilk çalışan fonksiyon
  @override
  void initState() {
    super.initState();
    _loadData(); // JSON dosyasından araçları yükle
  }

  /// Sayfadan çıkıldığında veya kapatıldığında çalışan temizlik fonksiyonu
  @override
  void dispose() {
    _searchController.dispose(); // Controller'ı dispose ederek bellek sızıntısını önle
    super.dispose();
  }

  /// Asenkron Veri Yükleme
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

  /// Bir kategori çipine (örn: 'Lux') tıklandığında Araç Listesi sayfasına yönlendir
  void _onCategorySelected(String category) {
    AppNavigation.toVehicleList(context, initialCategory: category);
  }

  /// Klavyeden arama onaylandığında filtreli listeye yönlendir
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
        /// 'RefreshIndicator':
        /// Kullanıcı sayfayı yukarıdan aşağıya çektiğinde (Pull to Refresh)
        /// JSON verisini zorla yeniden yükler (forceReload: true) ve sayfayı tazeler.
        child: RefreshIndicator(
          onRefresh: () async {
            await _dataSource.loadVehicles(forceReload: true);
            if (mounted) {
              setState(() {
                _featuredVehicles = _dataSource.getFeaturedVehicles();
              });
            }
          },
          /// 'SingleChildScrollView': Ekranın dikey olarak kaydırılabilmesini sağlar.
          /// 'AlwaysScrollableScrollPhysics': Ekran kısa olsa bile aşağı çekme (Refresh) hareketinin çalışmasını sağlar.
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Üst Başlık & Karşılama & Hızlı Tema Butonu
                _buildHeader(theme, colorScheme),

                const SizedBox(height: 16),

                // 2. Arama Kutusu (Search TextField)
                _buildSearchBar(theme, colorScheme, isDark),

                const SizedBox(height: 18),

                // 3. Hızlı Rezervasyon / Tarih & Konum Özeti Kartı
                _buildQuickRentalCard(theme, colorScheme, isDark),

                const SizedBox(height: 24),

                // 4. Araç Kategorileri (Yatay Çipler)
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

                // 5. Öne Çıkan Araçlar (Yatay Kart Listesi)
                AppSectionTitle(
                  title: 'Öne Çıkan Araçlar',
                  subtitle: 'En çok tercih edilen popüler modeller',
                  actionText: 'Tüm Araçlar',
                  onActionTap: () => AppNavigation.toVehicleList(context),
                ),
                _buildFeaturedList(theme),

                const SizedBox(height: 24),

                // 6. Temsili Şube Haritası
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


  /// Üst Başlık Bölümü: Karşılama metni ve tema değiştirici (Light/Dark Toggle)
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Sol taraftaki yuvarlak köşeli degrade araç ikonu
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
          /// Tema Değiştirme Butonu:
          /// 'ValueListenableBuilder' ile doğrudan themeController'ı dinler
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

  /// Arama Çubuğu (Search Bar)
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
          // Kullanıcı bir şey yazmışsa temizleme butonu 'X', boşsa filtre simgesi göster
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

  /// Hızlı Kiralama Planlama Kartı (Quick Rental Card)
  /// Kullanıcının lokasyon ve tarih seçip doğrudan araç listesine gitmesini sağlar.
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

          // Alış & Dönüş Noktası Seçim Alanları (Yan yana iki kutu)
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

          // Tarih Seçimi Özeti (Dokunulduğunda showDateRangePicker açar)
          InkWell(
            onTap: () async {
              /// 'showDateRangePicker': Flutter'ın yerleşik iki tarih arası seçici takvimi
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

          // 'Müsait Araçları Listele' Butonu
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

  /// Lokasyon Seçici Küçük Kutu Şablonu
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
              value.split(' - ').last, // Havalimanı veya şube adını kısaca göster
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  /// 'showModalBottomSheet' ile Alttan Açılan Şube Listesi Penceresi
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
                        Navigator.pop(context); // Seçim yapıldıktan sonra alt pencereyi kapat
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

  /// Öne Çıkan Araçlar Yatay Kart Listesi
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
      /// 'ListView.separated' ve 'scrollDirection: Axis.horizontal':
      /// Araçların yatayda kaydırılabilir bir kart şeridi halinde listelenmesini sağlar.
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

