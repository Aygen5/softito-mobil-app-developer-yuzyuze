import 'package:flutter/material.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/theme/app_colors.dart';

/// ============================================================================
/// RENTAL PRICE SUMMARY (KİRALAMA FİYAT ÖZETİ VE HESAP DÖKÜM KARTI)
/// ============================================================================
/// 
/// [RentalPriceSummary], seçilen tarih ve saat aralığına göre kiralama bedelinin
/// şeffaf bir dökümünü (günlük ücret, ekstra saatler, %15 uzun dönem indirimi
/// ve nihai toplam tutar) kullanıcıya sunan kart bileşenidir.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. İŞ MANTIĞININ UI'A YANSITILMASI (Domain Logic to UI):
///    - [AppPriceUtils.calculateRentalPrice] fonksiyonunu çağırarak
///      gün, saat, ham tutar, indirim tutarı ve nihai tutar verilerini alır.
/// 
/// 2. ŞARTLI ARAYÜZ OLUŞTURMA (Conditional UI Rendering):
///    - Eğer artık saat varsa (`calculation.hours > 0`), ekstra saat satırı eklenir.
///    - Eğer kiralama süresi 7 gün ve üzerindeyse (`calculation.isDiscountApplied`),
///      yeşil renkli indirim satırı `-₺X.XXX` şeklinde gösterilir.
/// 
/// 3. HİYERARŞİK GÖRSEL TASARIM (Visual Hierarchy):
///    - Ara hesaplamalar ikincil (gri) renklerle gösterilirken,
///      toplam tutar 20pt, kalın (w900) ve tema ana rengiyle öne çıkarılır.
class RentalPriceSummary extends StatelessWidget {
  /// Aracın 24 saatlik günlük kiralama bedeli
  final double dailyPrice;
  
  /// Aracın gün aşımındaki saatlik kiralama bedeli
  final double hourlyPrice;
  
  /// Alış tarihi ve saati (kombine DateTime)
  final DateTime startDateTime;
  
  /// Dönüş tarihi ve saati (kombine DateTime)
  final DateTime endDateTime;

  const RentalPriceSummary({
    super.key,
    required this.dailyPrice,
    required this.hourlyPrice,
    required this.startDateTime,
    required this.endDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // -----------------------------------------------------------------
    // FİYAT HESAPLAMA MOTORU ÇAĞRISI:
    // Dart 3 Record veya özel hesap nesnesi üzerinden dökümü alıyoruz
    // -----------------------------------------------------------------
    final calculation = AppPriceUtils.calculateRentalPrice(
      dailyPrice: dailyPrice,
      hourlyPrice: hourlyPrice,
      start: startDateTime,
      end: endDateTime,
    );

    return Container(
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
          // -----------------------------------------------------------
          // BAŞLIK VE TOPLAM SÜRE ROZETİ (Örn: "3 Gün 4 Saat")
          // -----------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fiyat Özeti',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${calculation.days} Gün ${calculation.hours > 0 ? '${calculation.hours} Saat' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // -----------------------------------------------------------
          // GÜNLÜK TABAN ÜCRET DÖKÜMÜ (Örn: ₺1.500 x 3 Gün = ₺4.500)
          // -----------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppPriceUtils.formatPrice(dailyPrice)} x ${calculation.days} Gün',
                style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
              ),
              Text(
                AppPriceUtils.formatPrice(dailyPrice * calculation.days),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          
          // -----------------------------------------------------------
          // EKSTRA SAAT ÜCRETİ (Sadece artık saat varsa görünür)
          // -----------------------------------------------------------
          if (calculation.hours > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ekstra ${calculation.hours} Saat (${AppPriceUtils.formatHourlyPrice(hourlyPrice)})',
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                ),
                Text(
                  AppPriceUtils.formatPrice(calculation.hours * hourlyPrice),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
          
          // -----------------------------------------------------------
          // %15 UZUN DÖNEM İNDİRİMİ (>= 7 gün kiralamalarda yeşil satır)
          // -----------------------------------------------------------
          if (calculation.isDiscountApplied) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.discount_rounded, size: 14, color: AppColors.successGreen),
                    SizedBox(width: 4),
                    Text(
                      'Uzun Dönem İndirimi (%15)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
                Text(
                  '-${AppPriceUtils.formatPrice(calculation.discountAmount)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.successGreen,
                  ),
                ),
              ],
            ),
          ],
          
          const Divider(height: 20),
          
          // -----------------------------------------------------------
          // NİHAİ TOPLAM TUTAR (Büyük ve Vurgulu)
          // -----------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Tutar',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              Text(
                AppPriceUtils.formatPrice(calculation.totalPrice),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

