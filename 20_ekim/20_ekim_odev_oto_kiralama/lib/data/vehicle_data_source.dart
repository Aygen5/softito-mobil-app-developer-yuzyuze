import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vehicle.dart';

class VehicleDataSource {
  static final VehicleDataSource _instance = VehicleDataSource._internal();
  factory VehicleDataSource() => _instance;
  VehicleDataSource._internal();

  List<Vehicle> _cachedVehicles = [];
  bool _isLoaded = false;

  List<Vehicle> get vehicles => List.unmodifiable(_cachedVehicles);
  bool get isLoaded => _isLoaded;

  // JSON dosyasından araçları yükle
  Future<List<Vehicle>> loadVehicles({bool forceReload = false}) async {
    if (_isLoaded && !forceReload) {
      return vehicles;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/vehicles.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      _cachedVehicles = jsonList
          .map((item) => Vehicle.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
      return vehicles;
    } catch (e) {
      // Hata durumunda boş liste ve hata fırlatma
      _isLoaded = false;
      throw Exception('Araç bilgileri yüklenemedi: $e');
    }
  }

  // ID'ye göre araç bul
  Vehicle? getVehicleById(String id) {
    try {
      return _cachedVehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  // Öne çıkan araçları getir (en popüler / yüksek donanımlı araçlar)
  List<Vehicle> getFeaturedVehicles() {
    if (_cachedVehicles.isEmpty) return [];
    // Örnek: her kategoriden öne çıkan bir araç seç
    return _cachedVehicles.where((v) => ['veh-001', 'veh-005', 'veh-007', 'veh-009', 'veh-011'].contains(v.id)).toList();
  }

  // Filtreleme fonksiyonu (Orijinal listeyi bozmadan yeni liste döner)
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
      // Kategori kontrolü
      if (category != null && category.isNotEmpty && category != 'Tümü') {
        if (v.category != category) return false;
      }

      // Marka kontrolü
      if (brand != null && brand.isNotEmpty && brand != 'Tümü') {
        if (v.brand.toLowerCase() != brand.toLowerCase()) return false;
      }

      // Vites türü kontrolü
      if (transmission != null && transmission.isNotEmpty && transmission != 'Tümü') {
        if (v.transmission != transmission) return false;
      }

      // Yakıt türü kontrolü
      if (fuelType != null && fuelType.isNotEmpty && fuelType != 'Tümü') {
        if (v.fuelType != fuelType) return false;
      }

      // Fiyat aralığı kontrolü
      if (minPrice != null && v.dailyPrice < minPrice) return false;
      if (maxPrice != null && v.dailyPrice > maxPrice) return false;

      // Arama metni kontrolü (Marka veya model içinde)
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesBrand = v.brand.toLowerCase().contains(query);
        final matchesModel = v.model.toLowerCase().contains(query);
        final matchesCategory = v.category.toLowerCase().contains(query);
        if (!matchesBrand && !matchesModel && !matchesCategory) return false;
      }

      return true;
    }).toList();
  }

  // Sıralama fonksiyonu
  List<Vehicle> sortVehicles(List<Vehicle> list, String sortOption) {
    final sorted = List<Vehicle>.from(list);
    switch (sortOption) {
      case 'price_asc':
        sorted.sort((a, b) => a.dailyPrice.compareTo(b.dailyPrice));
        break;
      case 'price_desc':
        sorted.sort((a, b) => b.dailyPrice.compareTo(a.dailyPrice));
        break;
      case 'year_desc':
        sorted.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'year_asc':
        sorted.sort((a, b) => a.year.compareTo(b.year));
        break;
      case 'mileage_asc':
        sorted.sort((a, b) => a.mileage.compareTo(b.mileage));
        break;
      default:
        break;
    }
    return sorted;
  }
}
