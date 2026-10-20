import 'package:flutter/material.dart';
import '../../../models/reservation.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/theme/app_colors.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onShowAgreement;
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
          // Üst Başlık & Durum Rozeti
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Küçük Araç Görseli
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
                // Araç Adı ve Rezervasyon No
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
                // Durum Etiketi
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

          // Tarih & Konum Bilgileri
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

          // Alt Tutar & Aksiyonlar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Row(
                  children: [
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
