import 'package:flutter_test/flutter_test.dart';
import 'package:rotarent/models/unavailable_range.dart';
import 'package:rotarent/models/vehicle.dart';
import 'package:rotarent/models/reservation.dart';

void main() {
  group('Veri Modelleri Testleri', () {
    test('UnavailableRange JSON serileştirme ve eşitlik', () {
      final start = DateTime(2026, 10, 20, 10, 0);
      final end = DateTime(2026, 10, 23, 18, 0);

      final range = UnavailableRange(startDate: start, endDate: end);
      final json = range.toJson();

      expect(json['startDate'], start.toIso8601String());
      expect(json['endDate'], end.toIso8601String());

      final fromJson = UnavailableRange.fromJson(json);
      expect(fromJson, equals(range));
    });

    test('Vehicle JSON serileştirme ve alanlar', () {
      final vehicle = Vehicle(
        id: 'test-1',
        brand: 'Renault',
        model: 'Clio',
        year: 2024,
        category: 'Basic',
        transmission: 'Otomatik',
        fuelType: 'Benzin',
        mileage: 15000,
        hourlyPrice: 120.0,
        dailyPrice: 1400.0,
        description: 'Ekonomik araç',
        image: 'assets/images/clio.jpg',
        images: ['assets/images/clio.jpg'],
        fuelLevel: 80,
        estimatedRange: 650,
        unavailableRanges: [
          UnavailableRange(
            startDate: DateTime(2026, 10, 22),
            endDate: DateTime(2026, 10, 25),
          ),
        ],
      );

      final json = vehicle.toJson();
      expect(json['brand'], 'Renault');
      expect(json['model'], 'Clio');
      expect(json['dailyPrice'], 1400.0);
      expect(vehicle.fullName, 'Renault Clio');

      final fromJson = Vehicle.fromJson(json);
      expect(fromJson.id, vehicle.id);
      expect(fromJson.unavailableRanges.length, 1);
    });

    test('Reservation JSON serileştirme ve durum özellikleri', () {
      final now = DateTime.now();
      final res = Reservation(
        id: 'REZ-100',
        vehicleId: 'test-1',
        vehicleName: 'Renault Clio',
        vehicleImage: 'img.jpg',
        startDateTime: now.add(const Duration(days: 1)),
        endDateTime: now.add(const Duration(days: 3)),
        pickupLocation: 'İST',
        returnLocation: 'İST',
        totalPrice: 2800.0,
        status: 'Onaylandı',
        createdAt: now,
      );

      expect(res.isActive, true);
      expect(res.isCompleted, false);

      final completedRes = res.copyWith(status: 'Tamamlandı');
      expect(completedRes.isActive, false);
      expect(completedRes.isCompleted, true);
    });
  });
}
