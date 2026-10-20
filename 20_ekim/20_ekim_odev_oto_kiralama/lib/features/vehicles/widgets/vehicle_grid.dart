import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import 'vehicle_card.dart';

/// ---------------------------------------------------------------------------
/// 🏁 VehicleGrid — Çoklu Düzen Araç Izgarası (Adaptive Grid/List Layout)
/// ---------------------------------------------------------------------------
/// Kullanıcının seçtiği sütun sayısına (1, 2 veya 3) göre dinamik olarak:
/// - 1 Sütun: Geniş dikey liste (`ListView.separated`). Büyük görseller ve geniş metinler.
/// - 2 Sütun: Standart mobil e-ticaret ızgarası (`GridView.builder`, 2 kolon).
/// - 3 Sütun: Kompakt karşılaştırma ızgarası (`GridView.builder`, 3 kolon).
///
/// 📐 'childAspectRatio' (En-Boy Oranı):
/// GridView'da hücrelerin yüksekliğini doğrudan piksel olarak veremeyiz.
/// Bunun yerine 'genişlik / yükseklik' (childAspectRatio) oranı verilir.
/// Örneğin 0.72 demek: Genişlik 100 birim ise yükseklik yaklaşık 138 birimdir.
class VehicleGrid extends StatelessWidget {
  final List<Vehicle> vehicles;            // Listelenecek araçlar
  final int columnCount;                   // 1, 2 veya 3 sütun
  final ValueChanged<Vehicle> onVehicleTap;// Araca tıklandığında detay sayfasına yönlendiren fonksiyon

  const VehicleGrid({
    super.key,
    required this.vehicles,
    required this.columnCount,
    required this.onVehicleTap,
  });

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // 1️⃣ Tek Sütunlu Liste Görünümü (ListView)
    // -------------------------------------------------------------------------
    if (columnCount == 1) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 1, // Karta 1 sütun modunda olduğunu bildirir
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    }
    // -------------------------------------------------------------------------
    // 2️⃣ İki Sütunlu Izgara Görünümü (GridView - 2 Kolon)
    // -------------------------------------------------------------------------
    else if (columnCount == 2) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,        // 2 sütun
          crossAxisSpacing: 12,      // Sütunlar arası yatay boşluk
          mainAxisSpacing: 12,       // Satırlar arası dikey boşluk
          childAspectRatio: 0.72,    // En / boy oranı (Görsel ve başlıklar sığacak yükseklik)
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 2, // Karta 2 sütun modunda olduğunu bildirir
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    }
    // -------------------------------------------------------------------------
    // 3️⃣ Üç Sütunlu Kompakt Görünüm (GridView - 3 Kolon)
    // -------------------------------------------------------------------------
    else {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,        // 3 sütun
          crossAxisSpacing: 8,       // Daha dar boşluklar
          mainAxisSpacing: 8,
          childAspectRatio: 0.68,    // Daha uzun ince hücreler
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 3, // Karta 3 sütun modunda olduğunu bildirir (ikonlar küçülür)
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    }
  }
}

