import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/price_utils.dart';

/// ============================================================================
/// FUEL PRICES DIALOG (GÜNCEL YAKIT FİYATLARI BİLGİLENDİRME DİYALOĞU)
/// ============================================================================
/// 
/// [FuelPricesDialog], kullanıcının araç kiralarken yakıt masrafını kestirebilmesi
/// amacıyla benzin, motorin, lpg ve elektrik kWh demo fiyatlarını listeleyen
/// bir [AlertDialog] kalıbıdır.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. ALERTDIALOG KALIBI (Material Dialog Pattern):
///    - `title`, `content` ve `actions` (kapat/tamam butonları) ile
///      standart Material 3 diyalog yapısı uygulanır.
/// 
/// 2. HARİTA (MAP) ÜZERİNDE DÖNGÜ (Map.entries.map):
///    - `AppConstants.sampleFuelPrices.entries.map(...)` kullanılarak
///      Key (Yakıt türü adı) ve Value (Litre fiyatı) çiftleri dinamik satırlara dönüştürülür.
/// 
/// 3. MAINAXISSIZE.MIN KULLANIMI:
///    - Dikeyde Column'un tüm ekranı kaplamaması, içeriği kadar yer kaplaması
///      için `mainAxisSize: MainAxisSize.min` verilir (Diyaloglarda çok önemlidir).
class FuelPricesDialog extends StatelessWidget {
  const FuelPricesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      // Diyalog Başlık Alanı
      title: Row(
        children: [
          Icon(Icons.local_gas_station_rounded, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Güncel Yakıt Fiyatları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
      // Diyalog İçerik Alanı
      content: Column(
        mainAxisSize: MainAxisSize.min, // İçeriği kadar yer kaplasın
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aşağıdaki fiyatlar bilgi ve demo amaçlı temsili piyasa ortalamalarını göstermektedir.',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          // Sabitlerdeki yakıt fiyatları map'ini liste satırlarına dönüştürüyoruz
          ...AppConstants.sampleFuelPrices.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${AppPriceUtils.formatPrice(entry.value)} / L',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      // Diyalog Aksiyon Butonları
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Diyaloğu kapat
          child: const Text('Anladım'),
        ),
      ],
    );
  }
}

