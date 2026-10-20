import 'package:flutter/material.dart';
import '../../../models/reservation.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/theme/app_colors.dart';

/// ============================================================================
/// RESERVATION CARD (REZERVASYON LİSTE KARTI BİLEŞENİ)
/// ============================================================================
/// 
/// [ReservationCard], kullanıcının yapmış olduğu bir araç kiralama rezervasyonunun
/// tüm detaylarını (araç görseli, model adı, PNR kodu, durum rozeti, alış/teslim
/// tarihleri ve toplam bedel) derli toplu gösteren kart widget'ıdır.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. SEMANTİK DURUM RENKLENDİRMESİ:
///    - [AppColors.getStatusColor] ile rezervasyon durumu ("Onaylandı",
///      "Tamamlandı", "İptal Edildi") anında yeşil, mavi veya kırmızı renge bürünür.
/// 
/// 2. HATA TOLERANSLI GÖRSEL YÜKLEME:
///    - `Image.network` üzerinde `errorBuilder` tanımlanarak ağ hatasında
///      veya geçersiz resim linkinde arayüzün çökmesi engellenir, zarif bir araba ikonu gösterilir.
/// 
/// 3. ŞARTLI BUTON GÖSTERİMİ:
///    - Sadece aktif olan (`reservation.isActive`) rezervasyonlarda kırmızı renkli
///      "İptal Et" butonu belirir; tamamlanmış veya zaten iptal edilmiş rezervasyonlarda gösterilmez.
class ReservationCard extends StatelessWidget {
  /// Kartın göstereceği rezervasyon verisi
  final Reservation reservation;
  
  /// Sözleşmeyi göster butonuna tıklandığında çalışacak callback
  final VoidCallback onShowAgreement;
  
  /// Rezervasyonu iptal et butonuna tıklandığında çalışacak callback (null ise buton gizlenir)
  final VoidCallback? onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onShowAgreement,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    // Rezervasyon durumuna göre renk (Onaylandı: Yeşil, İptal: Kırmızı, vb.)
    final statusColor = AppColors.getStatusColor(reservation.status);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------
          // 1. ÜST BAŞLIK, MİNİ ARAÇ GÖRSELİ VE DURUM ROZETİ
          // -----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Küçük Araç Küçük Resmi (Thumbnail)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    reservation.vehicleImage,
                    fit: BoxFit.cover,
                    // Resim yüklenemezse veya çevrimdışıysa çökmemesi için fallback:
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.directions_car_rounded,
                        size: 26,
                        color: colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Araç Adı ve Rezervasyon No (PNR)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.vehicleName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reservation.id,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Durum Rozeti (Örn: "Onaylandı")
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    reservation.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // -----------------------------------------------------------
          // 2. KİRALAMA TARİHLERİ VE OFİS/LOKASYON BİLGİLERİ
          // -----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Kiralama Süresi:',
                  value: '${AppDateUtils.formatDateTime(reservation.startDateTime)} → ${AppDateUtils.formatDateTime(reservation.endDateTime)}',
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: Icons.place_rounded,
                  label: 'Teslim:',
                  value: '${reservation.pickupLocation.split(' - ').last} → ${reservation.returnLocation.split(' - ').last}',
                  colorScheme: colorScheme,
                ),
                // Eğer kullanıcı hedef şehir girdiyse rota satırı eklenir
                if (reservation.destinationCity != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.alt_route_rounded,
                    label: 'Rota:',
                    value: reservation.destinationCity!,
                    colorScheme: colorScheme,
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // -----------------------------------------------------------
          // 3. TOPLAM TUTAR VE AKSİYON BUTONLARI (Sözleşme / İptal)
          // -----------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol Bölüm: Toplam Fiyat
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toplam Tutar',
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      AppPriceUtils.formatPrice(reservation.totalPrice),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                
                // Sağ Bölüm: Aksiyon Butonları
                Row(
                  children: [
                    // Sözleşmeyi Görüntüle Butonu
                    OutlinedButton(
                      onPressed: onShowAgreement,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Sözleşme', style: TextStyle(fontSize: 12)),
                    ),
                    // Sadece aktif rezervasyonlarda iptal seçeneği sunulur
                    if (reservation.isActive && onCancel != null) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.errorRed,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('İptal Et', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bilgi satırlarını (ikon + etiket + değer) düzenli basan yardımcı metot
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

