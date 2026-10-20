import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class RentalDateForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String pickupLocation;
  final String returnLocation;
  final TimeOfDay pickupTime;
  final TimeOfDay returnTime;
  final TextEditingController destinationCityController;
  final ValueChanged<String> onPickupLocationChanged;
  final ValueChanged<String> onReturnLocationChanged;
  final ValueChanged<TimeOfDay> onPickupTimeChanged;
  final ValueChanged<TimeOfDay> onReturnTimeChanged;

  const RentalDateForm({
    super.key,
    required this.formKey,
    required this.pickupLocation,
    required this.returnLocation,
    required this.pickupTime,
    required this.returnTime,
    required this.destinationCityController,
    required this.onPickupLocationChanged,
    required this.onReturnLocationChanged,
    required this.onPickupTimeChanged,
    required this.onReturnTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alış & Dönüş Noktaları
          Row(
            children: [
              Expanded(
                child: _buildLocationDropdown(
                  context: context,
                  label: 'Alış Noktası',
                  value: pickupLocation,
                  icon: Icons.trip_origin_rounded,
                  onChanged: onPickupLocationChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocationDropdown(
                  context: context,
                  label: 'Dönüş Noktası',
                  value: returnLocation,
                  icon: Icons.place_rounded,
                  onChanged: onReturnLocationChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Alış & Dönüş Saatleri
          Row(
            children: [
              Expanded(
                child: _buildTimePicker(
                  context: context,
                  label: 'Alış Saati',
                  time: pickupTime,
                  onTimeSelected: onPickupTimeChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePicker(
                  context: context,
                  label: 'Dönüş Saati',
                  time: returnTime,
                  onTimeSelected: onReturnTimeChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // İsteğe Bağlı Gidilecek Şehir
          TextFormField(
            controller: destinationCityController,
            decoration: const InputDecoration(
              labelText: 'Gidilecek Şehir (İsteğe Bağlı)',
              hintText: 'Örn: Ankara, İzmir, Bursa...',
              prefixIcon: Icon(Icons.alt_route_rounded),
            ),
          ),

          const SizedBox(height: 10),

          // 250 KM Günlük Kullanım Bilgi Notu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.speed_rounded, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'RotaRent araçlarında günlük ${AppConstants.dailyKmAllowance} km kullanım hakkı bulunmaktadır.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                ...AppConstants.pickupLocations.map((loc) => ListTile(
                  leading: Icon(icon, color: colorScheme.primary),
                  title: Text(loc, style: const TextStyle(fontSize: 13)),
                  selected: loc == value,
                  onTap: () {
                    onChanged(loc);
                    Navigator.pop(ctx);
                  },
                )),
              ],
            ),
          ),
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value.split(' - ').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Icon(Icons.schedule_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
