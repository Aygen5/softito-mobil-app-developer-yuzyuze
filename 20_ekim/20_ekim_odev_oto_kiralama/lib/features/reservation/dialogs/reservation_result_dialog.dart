import 'package:flutter/material.dart';
import '../../../models/reservation.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/widgets/app_button.dart';

/// ============================================================================
/// RESERVATION RESULT DIALOG (REZERVASYON ONAY VE DEKONT POPUP'I)
/// ============================================================================
/// 
/// [ReservationResultDialog], rezervasyon işlemi başarıyla tamamlandığında
/// ekrana gelen, kullanıcıya PNR rezervasyon kodunu ve kiralama özetini
/// (araç, tarihler, ofisler, toplam tutar) dekont şeklinde sunan diyalogdur.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. ÖZEL DIALOG (Custom Dialog Widget):
///    - `AlertDialog` yerine genel `Dialog` widget'ı kullanılarak tam kontrollü,
///      yuvarlatılmış ve özel dolgulu bir modal kart tasarlanmıştır.
/// 
/// 2. GERİ ÇAĞIRMA (CALLBACK) İLE SAYFA DEĞİŞİMİ:
///    - [onGoToReservations] callback'i ile dialog kapandıktan sonra
///      ana kabuktaki `Hesabım / Rezervasyonlarım` sekmesine otomatik geçiş sağlanır.
/// 
/// 3. BİLEŞEN YENİDEN KULLANIMI:
///    - Tablo satırları tekrara düşmemek için `_buildRow` adında modüler
///      bir yardımcı fonksiyonla üretilir.
class ReservationResultDialog extends StatelessWidget {
  /// Yeni oluşturulan rezervasyon nesnesi (tüm özet verileri içerir)
  final Reservation reservation;
  
  /// Kullanıcı "Rezervasyonlarıma Git" butonuna bastığında çalışacak fonksiyon
  final VoidCallback onGoToReservations;

  const ReservationResultDialog({
    super.key,
    required this.reservation,
    required this.onGoToReservations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      // 24 piksel yuvarlatılmış modern diyalog köşeleri
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ekranı dikeyde gereksiz uzatmaz
          children: [
            // ---------------------------------------------------------
            // 1. BAŞARI SİMGESİ (Yeşil Daire İçinde Check İkonu)
            // ---------------------------------------------------------
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            
            // ---------------------------------------------------------
            // 2. TEBRİK VE BİLGİLENDİRME BAŞLIĞI
            // ---------------------------------------------------------
            const Text(
              'Rezervasyon Oluşturuldu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Rezervasyon numaranız ve ayrıntılarınız aşağıda özetlenmiştir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 3. REZERVASYON ÖZET KARTI (VOUCHER / DEKONT GÖRÜNÜMÜ)
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildRow('Rezervasyon No:', reservation.id, isBold: true, highlight: true, colorScheme: colorScheme),
                  const Divider(height: 16),
                  _buildRow('Araç:', reservation.vehicleName, isBold: true, colorScheme: colorScheme),
                  const SizedBox(height: 6),
                  _buildRow('Alış Tarihi:', AppDateUtils.formatDateTime(reservation.startDateTime), colorScheme: colorScheme),
                  const SizedBox(height: 6),
                  _buildRow('Dönüş Tarihi:', AppDateUtils.formatDateTime(reservation.endDateTime), colorScheme: colorScheme),
                  const SizedBox(height: 6),
                  _buildRow('Alış Noktası:', reservation.pickupLocation.split(' - ').last, colorScheme: colorScheme),
                  const SizedBox(height: 6),
                  _buildRow('Dönüş Noktası:', reservation.returnLocation.split(' - ').last, colorScheme: colorScheme),
                  const Divider(height: 16),
                  _buildRow('Toplam Tutar:', AppPriceUtils.formatPrice(reservation.totalPrice), isBold: true, highlight: true, colorScheme: colorScheme),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------------------------------------------------------
            // 4. AKSİYON BUTONLARI: REZERVASYONLARIMA GİT & KAPAT
            // ---------------------------------------------------------
            AppButton(
              text: 'Rezervasyonlarıma Git',
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                Navigator.pop(context); // Önce diyaloğu kapatıyoruz
                onGoToReservations(); // Sonra rezervasyonlar sayfasına yönlendiriyoruz
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dekont içindeki her bir anahtar-değer satırını oluşturan yardımcı metot
  Widget _buildRow(String title, String value, {bool isBold = false, bool highlight = false, required ColorScheme colorScheme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

