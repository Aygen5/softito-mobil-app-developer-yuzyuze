import 'package:flutter/foundation.dart';
import '../models/reservation.dart';
import '../models/vehicle.dart';
import '../core/utils/date_utils.dart';

class ReservationStore extends ValueNotifier<List<Reservation>> {
  static final ReservationStore _instance = ReservationStore._internal();
  factory ReservationStore() => _instance;

  ReservationStore._internal() : super([]) {
    _initSampleReservations();
  }

  // Başlangıç için örnek rezervasyonlar yükle
  void _initSampleReservations() {
    final now = DateTime.now();
    value = [
      Reservation(
        id: 'REZ-2026-9041',
        vehicleId: 'veh-001',
        vehicleName: 'Fiat Egea Sedan',
        vehicleImage: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
        startDateTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
        endDateTime: DateTime(now.year, now.month, now.day + 5, 18, 0),
        pickupLocation: 'İstanbul - Havalimanı (IST)',
        returnLocation: 'İstanbul - Havalimanı (IST)',
        destinationCity: 'Bursa',
        totalPrice: 3750.0,
        status: 'Onaylandı',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Reservation(
        id: 'REZ-2026-8812',
        vehicleId: 'veh-005',
        vehicleName: 'Toyota Corolla Hybrid',
        vehicleImage: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?auto=format&fit=crop&w=800&q=80',
        startDateTime: DateTime(now.year, now.month, now.day - 7, 09, 0),
        endDateTime: DateTime(now.year, now.month, now.day - 4, 18, 0),
        pickupLocation: 'İstanbul - Sabiha Gökçen Havalimanı (SAW)',
        returnLocation: 'İstanbul - Kadıköy Rıhtım Şube',
        destinationCity: 'Yalova',
        totalPrice: 6300.0,
        status: 'Tamamlandı',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
    ];
  }

  // Aktif rezervasyonlar
  List<Reservation> get activeReservations =>
      value.where((r) => r.isActive).toList();

  // Geçmiş rezervasyonlar
  List<Reservation> get pastReservations =>
      value.where((r) => r.isCompleted).toList();

  // Yeni rezervasyon ekle
  void addReservation(Reservation reservation) {
    value = [reservation, ...value];
  }

  // Rezervasyon iptal et
  bool cancelReservation(String reservationId) {
    final index = value.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final updatedList = List<Reservation>.from(value);
      updatedList[index] = updatedList[index].copyWith(status: 'İptal Edildi');
      value = updatedList;
      return true;
    }
    return false;
  }

  // Belirli bir aracın belirli bir tarih aralığında müsait olup olmadığını kontrol et
  // Hem JSON'daki unavailableRanges hem de bellekteki aktif rezervasyonlar taranır
  ({bool isAvailable, String? errorMessage}) checkVehicleAvailability({
    required Vehicle vehicle,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) {
    // 1. Kural: Geçmiş tarihler için rezervasyon oluşturulamaz
    if (AppDateUtils.isPastDate(startDateTime)) {
      return (
        isAvailable: false,
        errorMessage: 'Geçmiş tarihler için kiralama oluşturulamaz.',
      );
    }

    // 2. Kural: Dönüş tarihi alış tarihinden önce veya eşit olamaz
    if (!endDateTime.isAfter(startDateTime)) {
      return (
        isAvailable: false,
        errorMessage: 'Dönüş tarihi ve saati, alış tarihinden sonra olmalıdır.',
      );
    }

    // 3. Kural: JSON'da tanımlı dolu tarih aralıkları kontrolü
    for (final range in vehicle.unavailableRanges) {
      if (AppDateUtils.hasDateOverlap(
        start1: startDateTime,
        end1: endDateTime,
        start2: range.startDate,
        end2: range.endDate,
      )) {
        return (
          isAvailable: false,
          errorMessage: 'Seçtiğiniz tarih aralığında araç müsait değil (Önceden Rezerve Edilmiş).',
        );
      }
    }

    // 4. Kural: Bellekteki aktif rezervasyonların çakışma kontrolü
    final vehicleActiveReservations = value.where(
      (r) => r.vehicleId == vehicle.id && r.isActive,
    );

    for (final reservation in vehicleActiveReservations) {
      if (AppDateUtils.hasDateOverlap(
        start1: startDateTime,
        end1: endDateTime,
        start2: reservation.startDateTime,
        end2: reservation.endDateTime,
      )) {
        return (
          isAvailable: false,
          errorMessage: 'Seçtiğiniz tarih aralığında bu araca ait onaylı bir rezervasyon bulunmaktadır.',
        );
      }
    }

    return (isAvailable: true, errorMessage: null);
  }

  // Belirli bir takvim gününün bu araç için dolu olup olmadığını sorgula (Takvimde kırmızı boyama için)
  bool isDayUnavailableForVehicle(Vehicle vehicle, DateTime day) {
    // Geçmiş günler kiralanamaz
    if (AppDateUtils.isPastDate(day)) {
      return false; // Geçmiş günler takvimde pasif/gri gösterilir
    }

    // JSON'daki dolu gün aralıkları
    for (final range in vehicle.unavailableRanges) {
      if (AppDateUtils.isDayWithinRange(day, range.startDate, range.endDate)) {
        return true;
      }
    }

    // Bellekteki aktif rezervasyon günleri
    final vehicleActiveReservations = value.where(
      (r) => r.vehicleId == vehicle.id && r.isActive,
    );

    for (final res in vehicleActiveReservations) {
      if (AppDateUtils.isDayWithinRange(day, res.startDateTime, res.endDateTime)) {
        return true;
      }
    }

    return false;
  }
}

// Global rezervasyon deposu
final ReservationStore reservationStore = ReservationStore();
