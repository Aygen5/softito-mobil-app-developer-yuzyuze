import 'package:flutter_test/flutter_test.dart';
import 'package:rotarent/core/utils/date_utils.dart';
import 'package:rotarent/core/utils/price_utils.dart';
import 'package:rotarent/models/unavailable_range.dart';
import 'package:rotarent/models/vehicle.dart';
import 'package:rotarent/models/reservation.dart';
import 'package:rotarent/data/reservation_store.dart';

void main() {
  group('Tarih ve Çakışma Mantığı Testleri', () {
    test('Türkçe tarih formatı dd.MM.yyyy biçiminde olmalıdır', () {
      final date = DateTime(2026, 10, 20);
      expect(AppDateUtils.formatDate(date), '20.10.2026');
    });

    test('Tarih çakışması (Overlap) doğru tespit edilmelidir', () {
      final start1 = DateTime(2026, 10, 22, 10, 0);
      final end1 = DateTime(2026, 10, 25, 18, 0);

      // Tam ortasında çakışan aralık
      final start2 = DateTime(2026, 10, 23, 12, 0);
      final end2 = DateTime(2026, 10, 24, 12, 0);
      expect(AppDateUtils.hasDateOverlap(
        start1: start1,
        end1: end1,
        start2: start2,
        end2: end2,
      ), true);

      // Tamamen önce olan aralık (çakışma yok)
      final startBefore = DateTime(2026, 10, 18, 10, 0);
      final endBefore = DateTime(2026, 10, 21, 18, 0);
      expect(AppDateUtils.hasDateOverlap(
        start1: start1,
        end1: end1,
        start2: startBefore,
        end2: endBefore,
      ), false);
    });

    test('Bitişik rezervasyon kuralı: Teslim anında yeni kiralama başlayabilmelidir', () {
      final existingStart = DateTime(2026, 10, 22, 10, 0);
      final existingEnd = DateTime(2026, 10, 25, 12, 0);

      // Yeni kiralama tam olarak önceki kiralamanın bitiş saatinde başlıyor (12:00)
      final newStart = DateTime(2026, 10, 25, 12, 0);
      final newEnd = DateTime(2026, 10, 28, 18, 0);

      // Çakışma OLMAMALIDIR (izin verilir)
      expect(AppDateUtils.hasDateOverlap(
        start1: existingStart,
        end1: existingEnd,
        start2: newStart,
        end2: newEnd,
      ), false);
    });
  });

  group('Fiyat Hesaplama Testleri', () {
    test('3 günlük standart kiralama doğru hesaplanmalıdır', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 23, 10, 0); // 3 tam gün

      final result = AppPriceUtils.calculateRentalPrice(
        dailyPrice: 1500.0,
        hourlyPrice: 150.0,
        start: start,
        end: end,
      );

      expect(result.days, 3);
      expect(result.hours, 0);
      expect(result.isDiscountApplied, false);
      expect(result.totalPrice, 4500.0);
    });

    test('7 gün ve üzeri kiralamalarda %15 indirim uygulanmalıdır', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 27, 10, 0); // 7 tam gün

      final result = AppPriceUtils.calculateRentalPrice(
        dailyPrice: 1000.0,
        hourlyPrice: 100.0,
        start: start,
        end: end,
      );

      expect(result.days, 7);
      expect(result.isDiscountApplied, true);
      expect(result.basePrice, 7000.0);
      expect(result.discountAmount, 1050.0); // %15 indirim
      expect(result.totalPrice, 5950.0);
    });
  });

  group('Dinamik Müsaitlik ve Rezervasyon Yönetimi Testleri', () {
    final vehicle = Vehicle(
      id: 'test-car',
      brand: 'Fiat',
      model: 'Egea',
      year: 2024,
      category: 'Basic',
      transmission: 'Manuel',
      fuelType: 'Benzin',
      mileage: 10000,
      hourlyPrice: 100.0,
      dailyPrice: 1200.0,
      description: 'Test aracı',
      image: '',
      images: [],
      fuelLevel: 90,
      estimatedRange: 700,
      unavailableRanges: [
        UnavailableRange(
          startDate: DateTime(2026, 11, 10, 10, 0),
          endDate: DateTime(2026, 11, 15, 18, 0),
        ),
      ],
    );

    test('Dolu tarih aralığı için rezervasyon reddedilmelidir', () {
      final store = ReservationStore();

      final check = store.checkVehicleAvailability(
        vehicle: vehicle,
        startDateTime: DateTime(2026, 11, 12, 10, 0),
        endDateTime: DateTime(2026, 11, 14, 18, 0),
      );

      expect(check.isAvailable, false);
      expect(check.errorMessage, isNotNull);
    });

    test('Müsait tarih aralığı için onay verilmelidir', () {
      final store = ReservationStore();

      final check = store.checkVehicleAvailability(
        vehicle: vehicle,
        startDateTime: DateTime(2026, 11, 16, 10, 0),
        endDateTime: DateTime(2026, 11, 18, 18, 0),
      );

      expect(check.isAvailable, true);
      expect(check.errorMessage, isNull);
    });

    test('Bellekte yeni oluşturulan rezervasyon sonraki müsaitlik kontrolünü etkilemelidir', () {
      final store = ReservationStore();

      final requestedStart = DateTime(2026, 11, 20, 10, 0);
      final requestedEnd = DateTime(2026, 11, 23, 18, 0);

      // Başlangıçta müsait
      final checkBefore = store.checkVehicleAvailability(
        vehicle: vehicle,
        startDateTime: requestedStart,
        endDateTime: requestedEnd,
      );
      expect(checkBefore.isAvailable, true);

      // Yeni rezervasyon oluşturup ekliyoruz
      final newRes = Reservation(
        id: 'TEST-REZ-999',
        vehicleId: vehicle.id,
        vehicleName: vehicle.fullName,
        vehicleImage: '',
        startDateTime: requestedStart,
        endDateTime: requestedEnd,
        pickupLocation: 'İST',
        returnLocation: 'İST',
        totalPrice: 3600.0,
        status: 'Onaylandı',
        createdAt: DateTime.now(),
      );
      store.addReservation(newRes);

      // Artık aynı aralık dolu olmalıdır!
      final checkAfter = store.checkVehicleAvailability(
        vehicle: vehicle,
        startDateTime: requestedStart,
        endDateTime: requestedEnd,
      );
      expect(checkAfter.isAvailable, false);
    });
  });
}
