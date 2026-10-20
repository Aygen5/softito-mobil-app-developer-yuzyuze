import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vehicle.dart';

/// 🗄️ VehicleDataSource — Araç Veri Kaynağı ve Servis Katmanı

/// Bu sınıf; 'assets/data/vehicles.json' dosyasından veriyi okur, bellekte önbelleğe alır (cache) ve araçlar üzerinde filtreleme/sıralama yapılmasına olanak tanır.

/// Tasarım Deseni: Singleton (Tekil Nesne Kalıbı) Neden Singleton?
/// Uygulamanın 10 farklı ekranında araç listesine ihtiyaç duyabiliriz.
/// Her ekranda `new VehicleDataSource()` yapıp JSON dosyasını diskten tekrar tekrar okumak hem bellek israfına hem de performans kaybına yol açar.
/// Singleton kalıbı sayesinde bu sınıftan uygulama boyunca YALNIZCA BİR TEK nesne örneği oluşturulur.

class VehicleDataSource {
  // 1. Sınıfın statik ve değiştirilemez tek örneği
  static final VehicleDataSource _instance = VehicleDataSource._internal();

  // 2. Factory yapıcı: Dışarıdan `VehicleDataSource()` çağrıldığında hep aynı örneği döner
  factory VehicleDataSource() => _instance;

  // 3. Private constructor: Sınıf dışından başka bir örnek üretilmesini engeller
  VehicleDataSource._internal();

  // Bellek İçi Önbellek (In-Memory Cache)
  List<Vehicle> _cachedVehicles = [];
  bool _isLoaded = false;

  /// 'List.unmodifiable':
  /// Dışarıdaki bir kodun `dataSource.vehicles.clear()` gibi zararlı işlemlerle önbelleğimizi bozamaması için listenin salt-okunur (read-only) bir görünümünü sunar.
  List<Vehicle> get vehicles => List.unmodifiable(_cachedVehicles);

  /// Verilerin belleğe yüklenip yüklenmediği bilgisi
  bool get isLoaded => _isLoaded;

  // 📥 JSON Dosyasından Veri Okuma (Asenkron İşlem)
  /// 'rootBundle.loadString':
  /// Flutter'ın 'pubspec.yaml' dosyasında tanımlanan statik asset dosyalarını (burada vehicles.json) string metin olarak diskten okuma fonksiyonudur.
  Future<List<Vehicle>> loadVehicles({bool forceReload = false}) async {
    // Veriler zaten hafızadaysa ve zorla yeniden yükleme istenmemişse direkt dön
    if (_isLoaded && !forceReload) {
      return vehicles;
    }

    try {
      // 1. JSON metnini oku
      final jsonString = await rootBundle.loadString('assets/data/vehicles.json');

      // 2. String metni Dart nesnelerine (List<dynamic>) ayrıştır (Parse/Decode)
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      // 3. Listedeki her bir JSON haritasını Vehicle nesnesine dönüştür
      _cachedVehicles = jsonList
          .map((item) => Vehicle.fromJson(item as Map<String, dynamic>))
          .toList();

      _isLoaded = true;
      return vehicles;
    } catch (e) {
      _isLoaded = false;
      throw Exception('Araç bilgileri yüklenemedi: $e');
    }
  }

  /// ID'ye göre tek bir aracı getirir
  /// 'firstWhere': Şarta uyan ilk elemanı bulur; bulamazsa catch ile null döner.
  Vehicle? getVehicleById(String id) {
    try {
      return _cachedVehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Ana sayfadaki yatay listede gösterilecek öne çıkan araçlar
  List<Vehicle> getFeaturedVehicles() {
    if (_cachedVehicles.isEmpty) return [];
    // Belirlenen popüler araç ID'lerine göre filtreler
    return _cachedVehicles.where((v) => ['veh-001', 'veh-005', 'veh-007', 'veh-009', 'veh-011'].contains(v.id)).toList();
  }

  // 🔍 Filtreleme Fonksiyonu (Filtering)
  /// Orijinal listeyi ASLA bozmaz. Verilen filtrelere (kategori, marka, vites, yakıt, fiyat, arama metni) uyan araçlardan oluşan YENİ bir liste üretip döndürür.
  List<Vehicle> filterVehicles({
    String? category,
    String? brand,
    String? transmission,
    String? fuelType,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) {
    return _cachedVehicles.where((v) {
      // 1. Kategori kontrolü
      if (category != null && category.isNotEmpty && category != 'Tümü') {
        if (v.category != category) return false;
      }

      // 2. Marka kontrolü
      if (brand != null && brand.isNotEmpty && brand != 'Tümü') {
        if (v.brand.toLowerCase() != brand.toLowerCase()) return false;
      }

      // 3. Vites türü kontrolü
      if (transmission != null && transmission.isNotEmpty && transmission != 'Tümü') {
        if (v.transmission != transmission) return false;
      }

      // 4. Yakıt türü kontrolü
      if (fuelType != null && fuelType.isNotEmpty && fuelType != 'Tümü') {
        if (v.fuelType != fuelType) return false;
      }

      // 5. Fiyat aralığı kontrolü
      if (minPrice != null && v.dailyPrice < minPrice) return false;
      if (maxPrice != null && v.dailyPrice > maxPrice) return false;

      // 6. Arama metni kontrolü (Marka, model veya kategori içinde büyük/küçük harf duyarsız arama)
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesBrand = v.brand.toLowerCase().contains(query);
        final matchesModel = v.model.toLowerCase().contains(query);
        final matchesCategory = v.category.toLowerCase().contains(query);
        if (!matchesBrand && !matchesModel && !matchesCategory) return false;
      }

      return true; // Tüm şartları geçtiyse listeye dahil et
    }).toList();
  }

  // 📶 Sıralama Fonksiyonu (Sorting)
  /// Seçilen kritere göre (fiyat artan/azalan, model yılı, kilometre) araçları dizer.
  /// `List<Vehicle>.from(list)`: Orijinal listeyi korumak için yeni bir kopya üzerinde sıralama yapar.
  List<Vehicle> sortVehicles(List<Vehicle> list, String sortOption) {
    final sorted = List<Vehicle>.from(list);
    switch (sortOption) {
      case 'price_asc': // Fiyat: Düşükten Yükseğe
        sorted.sort((a, b) => a.dailyPrice.compareTo(b.dailyPrice));
        break;
      case 'price_desc': // Fiyat: Yüksekten Düşüğe
        sorted.sort((a, b) => b.dailyPrice.compareTo(a.dailyPrice));
        break;
      case 'year_desc': // Model Yılı: En Yeni
        sorted.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'year_asc': // Model Yılı: En Eski
        sorted.sort((a, b) => a.year.compareTo(b.year));
        break;
      case 'mileage_asc': // Kilometre: En Düşük
        sorted.sort((a, b) => a.mileage.compareTo(b.mileage));
        break;
      default:
        break;
    }
    return sorted;
  }
}

