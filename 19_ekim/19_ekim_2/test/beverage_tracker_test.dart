import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/beverage_tracker/controller/beverage_tracker_controller.dart';
import 'package:susadim/features/beverage_tracker/models/beverage_type.dart';

void main() {
  group('BeverageTrackerController Tests', () {
    late BeverageTrackerController controller;

    setUp(() {
      controller = BeverageTrackerController();
      controller.resetToday(); // Temiz test ortamı
    });

    tearDown(() {
      controller.dispose();
    });

    test('Hydration calculation matches factor requirements for all beverage types', () {
      // Su: %100
      controller.addBeverage(BeverageType.water, 200);
      expect(controller.effectiveHydrationMl, equals(200));

      // Maden Suyu: %100
      controller.addBeverage(BeverageType.mineralWater, 200);
      expect(controller.effectiveHydrationMl, equals(400));

      // Çay: %90 (100ml * 0.9 = 90ml)
      controller.addBeverage(BeverageType.tea, 100);
      expect(controller.effectiveHydrationMl, equals(490));

      // Kahve: %80 (100ml * 0.8 = 80ml)
      controller.addBeverage(BeverageType.coffee, 100);
      expect(controller.effectiveHydrationMl, equals(570));

      // Toplam tüketilen sıvı (200 + 200 + 100 + 100 = 600ml)
      expect(controller.consumedMl, equals(600));
    });

    test('Breakdown map accurately sums amounts by beverage type', () {
      controller.addBeverage(BeverageType.tea, 100);
      controller.addBeverage(BeverageType.tea, 200);
      controller.addBeverage(BeverageType.coffee, 150);

      final breakdown = controller.consumptionByType;
      expect(breakdown[BeverageType.tea], equals(300));
      expect(breakdown[BeverageType.coffee], equals(150));
      expect(breakdown[BeverageType.water], equals(0));
      expect(breakdown[BeverageType.mineralWater], equals(0));
    });

    test('Progress ratio clamp to 1.0 when exceeding daily goal', () {
      controller.setDailyGoal(1000);
      controller.addBeverage(BeverageType.water, 1500);

      expect(controller.progressRatio, equals(1.0));
      expect(controller.remainingMl, equals(0));
    });
  });
}
