import 'package:flutter/material.dart';
import '../../../models/reservation.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/widgets/app_button.dart';

class ReservationResultDialog extends StatelessWidget {
  final Reservation reservation;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başarı Rozeti
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

            // Özet Kartı
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

            // Butonlar
            AppButton(
              text: 'Rezervasyonlarıma Git',
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
                onGoToReservations();
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
