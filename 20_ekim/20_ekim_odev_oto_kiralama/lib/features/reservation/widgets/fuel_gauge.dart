import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// ============================================================================
/// FUEL GAUGE (YAKIT SEVİYESİ VE TAHMİNİ MENZİL GÖSTERGESİ)
/// ============================================================================
/// 
/// [FuelGauge], aracın mevcut depo doluluk oranını (% cinsinden) ve depodaki
/// yakıtla tahmini olarak kaç kilometre yol yapılabileceğini şık bir görsel kart
/// içinde sunan bileşendir.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. DİNAMİK RENK EŞİKLERİ (Threshold Color Mapping):
///    - Depo %40'ın üzerindeyse güvenli/yeşil ([AppColors.successGreen]).
///    - Depo %20 ile %40 arasındaysa dikkat/turuncu ([AppColors.accentAmber]).
///    - Depo %20 ve altındaysa kritik/kırmızı ([AppColors.errorRed]).
///    - Böylece kullanıcı ilk bakışta aracın yakıt durumunu sezgisel kavrar.
/// 
/// 2. GÖRSEL İLERLEME ÇUBUĞU (LinearProgressIndicator & ClipRRect):
///    - Flutter'ın yerleşik [LinearProgressIndicator] widget'ı `value` olarak
///      0.0 ile 1.0 arasında bir oran bekler (`fuelLevel / 100.0`).
///    - [ClipRRect] kullanılarak çubuğun kenarları yuvarlatılır ve modern bir hap şekli elde edilir.
/// 
/// 3. ETKİLEŞİM VE TIKLANABİLİRLİK (InkWell & VoidCallback):
///    - Kullanıcı bu karta tıkladığında güncel piyasa yakıt litre fiyatlarını
///      gösteren popup açılır ([onTap] callback tetiklenir).
class FuelGauge extends StatelessWidget {
  /// Depo doluluk oranı (0 ile 100 arası tam sayı)
  final int fuelLevel;
  
  /// Bu yakıtla gidilebilecek yaklaşık mesafe (KM cinsinden)
  final int estimatedRange;
  
  /// Karta tıklandığında (yakıt fiyatları popup'ını açmak için) çalışacak fonksiyon
  final VoidCallback onTap;

  const FuelGauge({
    super.key,
    required this.fuelLevel,
    required this.estimatedRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // -----------------------------------------------------------------
    // DİNAMİK RENK BELİRLEME:
    // Depo seviyesine göre simge ve bar rengini anlık hesaplıyoruz
    // -----------------------------------------------------------------
    final fuelColor = fuelLevel > 40
        ? AppColors.successGreen
        : (fuelLevel > 20 ? AppColors.accentAmber : AppColors.errorRed);

    return InkWell(
      onTap: onTap, // Tıklama dalgalanma efekti (ripple) verir
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // ÜST BAŞLIK VE "FİYATLAR" BİLGİLENDİRME ETİKETİ
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station_rounded,
                      size: 20,
                      color: fuelColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Yakıt Seviyesi & Menzil',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Sağdaki ufak tıklanabilir "Fiyatlar (i)" uyarısı
                Row(
                  children: [
                    Text(
                      'Fiyatlar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // ---------------------------------------------------------
            // ALT KISIM: YÜZDE ÇUBUĞU (Flex 3) VE MENZİL KUTUSU (Flex 2)
            // ---------------------------------------------------------
            Row(
              children: [
                // Sol Bölüm: Yüzde Metni ve İlerleme Çubuğu (Bar)
                Expanded(
                  flex: 3, // Alanın %60'ını (3 / 5) bu sütuna ayırıyoruz
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Depo: %$fuelLevel',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: fuelColor,
                            ),
                          ),
                          Text(
                            'Dolu',
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Yuvarlatılmış köşeli ilerleme barı
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: fuelLevel / 100.0, // 0.0 - 1.0 aralığına normalize ediyoruz
                          backgroundColor: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                          color: fuelColor,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                
                // Sağ Bölüm: Tahmini Menzil Gösterge Rozeti
                Expanded(
                  flex: 2, // Alanın %40'ını (2 / 5) bu kutuya ayırıyoruz
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kalan Menzil',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '~$estimatedRange km',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

