import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../features/vehicles/screens/vehicle_list_screen.dart';
import '../../features/reservation/screens/vehicle_detail_screen.dart';

class AppNavigation {
  AppNavigation._();

  // Araç Listesi Ekranına git (Opsiyonel seçili kategori veya arama metni ile)
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

  // Araç Detay ve Rezervasyon Ekranına git
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

  // Geri dön
  static void goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
