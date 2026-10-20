import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import '../../../models/reservation.dart';
import '../../../data/reservation_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_section_title.dart';
import '../widgets/fuel_gauge.dart';
import '../widgets/availability_calendar.dart';
import '../widgets/rental_date_form.dart';
import '../widgets/rental_price_summary.dart';
import '../dialogs/fuel_prices_dialog.dart';
import '../dialogs/reservation_result_dialog.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationCityController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 18, minute: 0);

  String _pickupLocation = AppConstants.pickupLocations[0];
  String _returnLocation = AppConstants.pickupLocations[0];

  String? _calendarErrorMessage;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day + 1);
    _endDate = DateTime(now.year, now.month, now.day + 4);
  }

  @override
  void dispose() {
    _destinationCityController.dispose();
    super.dispose();
  }

  DateTime _buildFullDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _onBookPressed() {
    // 1. Form doğrulaması
    if (!_formKey.currentState!.validate()) {
      _showSnackbar('Lütfen tüm zorunlu alanları doldurun.', isError: true);
      return;
    }

    if (_calendarErrorMessage != null) {
      _showSnackbar(_calendarErrorMessage!, isError: true);
      return;
    }

    final startDateTime = _buildFullDateTime(_startDate, _pickupTime);
    final endDateTime = _buildFullDateTime(_endDate, _returnTime);

    // 2. Müsaitlik ve iş kuralı kontrolü
    final availability = reservationStore.checkVehicleAvailability(
      vehicle: widget.vehicle,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
    );

    if (!availability.isAvailable) {
      _showSnackbar(availability.errorMessage ?? 'Araç bu tarihlerde müsait değil.', isError: true);
      return;
    }

    setState(() {
      _isBooking = true;
    });

    // Fiyatı hesapla
    final pricing = AppPriceUtils.calculateRentalPrice(
      dailyPrice: widget.vehicle.dailyPrice,
      hourlyPrice: widget.vehicle.hourlyPrice,
      start: startDateTime,
      end: endDateTime,
    );

    // Yeni rezervasyon oluştur
    final randomId = 'REZ-2026-${(1000 + Random().nextInt(9000))}';
    final newReservation = Reservation(
      id: randomId,
      vehicleId: widget.vehicle.id,
      vehicleName: widget.vehicle.fullName,
      vehicleImage: widget.vehicle.image,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      pickupLocation: _pickupLocation,
      returnLocation: _returnLocation,
      destinationCity: _destinationCityController.text.trim().isNotEmpty
          ? _destinationCityController.text.trim()
          : null,
      totalPrice: pricing.totalPrice,
      status: 'Onaylandı',
      createdAt: DateTime.now(),
    );

    // Bellek deposuna kaydet
    reservationStore.addReservation(newReservation);

    setState(() {
      _isBooking = false;
    });

    // Başarı diyaloğunu göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReservationResultDialog(
        reservation: newReservation,
        onGoToReservations: () {
          // Geri dönüp rezervasyonlar sekmesine yönlendirme
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorRed : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(widget.vehicle.category);

    final startDateTime = _buildFullDateTime(_startDate, _pickupTime);
    final endDateTime = _buildFullDateTime(_endDate, _returnTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Paylaş',
            onPressed: () {
              _showSnackbar('Araç bağlantısı panoya kopyalandı.');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Araç Görseli
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  child: Image.network(
                    widget.vehicle.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        size: 72,
                        color: colorScheme.primary.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: catColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.vehicle.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.vehicle.year} Model',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marka, Model ve Fiyat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vehicle.brand,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              widget.vehicle.model,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppPriceUtils.formatPrice(widget.vehicle.dailyPrice),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            'günlük / ${AppPriceUtils.formatHourlyPrice(widget.vehicle.hourlyPrice)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Temel Teknik Özellikler Izgarası
                  Row(
                    children: [
                      _buildSpecItem(theme, Icons.settings_suggest_rounded, 'Vites', widget.vehicle.transmission),
                      const SizedBox(width: 8),
                      _buildSpecItem(theme, Icons.local_gas_station_rounded, 'Yakıt', widget.vehicle.fuelType),
                      const SizedBox(width: 8),
                      _buildSpecItem(theme, Icons.speed_rounded, 'Kilometre', '${widget.vehicle.mileage} km'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Yakıt Göstergesi & Kalan Menzil Kartı
                  FuelGauge(
                    fuelLevel: widget.vehicle.fuelLevel,
                    estimatedRange: widget.vehicle.estimatedRange,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const FuelPricesDialog(),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Açıklama
                  Text(
                    'Araç Hakkında',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.vehicle.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Dinamik Müsaitlik Takvimi
                  AppSectionTitle(
                    title: 'Dinamik Müsaitlik Takvimi',
                    subtitle: 'Kırmızı renkli günler dolu olup rezerve edilemez',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),
                  AvailabilityCalendar(
                    vehicle: widget.vehicle,
                    startDate: _startDate,
                    endDate: _endDate,
                    onDateRangeChanged: (start, end) {
                      setState(() {
                        _startDate = start;
                        if (end != null) {
                          _endDate = end;
                        }
                      });
                    },
                    onErrorMessageChanged: (err) {
                      setState(() {
                        _calendarErrorMessage = err;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Rezervasyon Bilgileri Formu
                  AppSectionTitle(
                    title: 'Teslimat ve Detaylar',
                    subtitle: 'Alış ve teslim noktalarını seçin',
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 12),
                  RentalDateForm(
                    formKey: _formKey,
                    pickupLocation: _pickupLocation,
                    returnLocation: _returnLocation,
                    pickupTime: _pickupTime,
                    returnTime: _returnTime,
                    destinationCityController: _destinationCityController,
                    onPickupLocationChanged: (loc) => setState(() => _pickupLocation = loc),
                    onReturnLocationChanged: (loc) => setState(() => _returnLocation = loc),
                    onPickupTimeChanged: (t) => setState(() => _pickupTime = t),
                    onReturnTimeChanged: (t) => setState(() => _returnTime = t),
                  ),

                  const SizedBox(height: 24),

                  // Fiyat Özeti
                  RentalPriceSummary(
                    dailyPrice: widget.vehicle.dailyPrice,
                    hourlyPrice: widget.vehicle.hourlyPrice,
                    startDateTime: startDateTime,
                    endDateTime: endDateTime,
                  ),

                  const SizedBox(height: 24),

                  // Rezervasyon Oluştur Butonu
                  AppButton(
                    text: 'Rezervasyonu Onayla ve Oluştur',
                    icon: Icons.check_circle_outline_rounded,
                    isLoading: _isBooking,
                    onPressed: _onBookPressed,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(ThemeData theme, IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
