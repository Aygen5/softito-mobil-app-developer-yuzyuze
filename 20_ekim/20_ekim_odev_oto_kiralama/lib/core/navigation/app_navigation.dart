import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../features/vehicles/screens/vehicle_list_screen.dart';
import '../../features/reservation/screens/vehicle_detail_screen.dart';

/// ---------------------------------------------------------------------------
/// 🧭 AppNavigation — Sayfa Yönlendirme ve Rota Yöneticisi
/// ---------------------------------------------------------------------------
/// Flutter'da sayfalar bir yığın (Stack) mantığıyla çalışır.
/// Yeni bir sayfa açıldığında bu yığının en üstüne konur (push),
/// geri dönüldüğünde en üstteki sayfa yığından atılır (pop).
///
/// Neden merkezi bir navigasyon sınıfı oluşturduk?
/// - Ekran geçişlerini her butonun içinde ayrı ayrı 'Navigator.push(MaterialPageRoute...)'
///   şeklinde yazmak yerine tek bir merkezden yönetiriz.
/// - Sayfaya gönderilen parametreleri (örn: initialCategory, vehicle) tip güvenli şekilde
///   tek bir fonksiyon imzasıyla kontrol ederiz.
class AppNavigation {
  /// Nesne üretilmesini önlemek için private constructor
  AppNavigation._();

  /// Araç Listesi Ekranına git
  /// [context]: Flutter'ın widget ağacındaki konum bilgisidir. Sayfa geçişlerinde zorunludur.
  /// [initialCategory]: Opsiyonel olarak belirli bir kategoriyi (örn: 'Lux') seçili açmak için.
  /// [initialSearchQuery]: Opsiyonel olarak arama çubuğundaki metinle filtrelemek için.
  static Future<void> toVehicleList(
    BuildContext context, {
    String? initialCategory,
    String? initialSearchQuery,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VehicleListScreen(
          initialCategory: initialCategory,
          initialSearchQuery: initialSearchQuery,
        ),
      ),
    );
  }

  /// Araç Detay ve Rezervasyon Ekranına git
  /// [vehicle]: Hangi aracın detayının gösterileceğini belirten zorunlu (required) veri modeli.
  static Future<void> toVehicleDetail(
    BuildContext context, {
    required Vehicle vehicle,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VehicleDetailScreen(vehicle: vehicle),
      ),
    );
  }

  /// Önceki sayfaya geri dön (Pop)
  /// 'canPop()': Yığında geri dönülebilecek bir sayfa olup olmadığını kontrol eder.
  /// En alt kök sayfadaysak uygulamanın beklenmedik şekilde kapanmasını önler.
  static void goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

