import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/beverage_tracker/controller/beverage_tracker_controller.dart';
import 'package:susadim/features/beverage_tracker/models/beverage_type.dart';

void main() {
  group('BeverageTrackerController Multi-Drink Tests', () {
    test('Default consumption initializes with 800ml water and 100% hydration', () {
      final controller = BeverageTrackerController();
      expect(controller.consumedMl, 800);
      expect(controller.effectiveHydrationMl, 800);
      expect(controller.dailyGoalMl, 2500);
    });

    test('Adding tea applies 90% hydration factor correctly', () {
      final controller = BeverageTrackerController();
      controller.addBeverage(BeverageType.tea, 200, 'Kupa Çay');
      expect(controller.consumedMl, 1000); // 800 + 200
      // effective: 800 + (200 * 0.9 = 180) = 980
      expect(controller.effectiveHydrationMl, 980);
      expect(controller.logs.first.type, BeverageType.tea);
    });

    test('Adding coffee applies 80% hydration factor correctly', () {
      final controller = BeverageTrackerController();
      controller.addBeverage(BeverageType.coffee, 150, 'Filtre');
      expect(controller.consumedMl, 950);
      // effective: 800 + (150 * 0.8 = 120) = 920
      expect(controller.effectiveHydrationMl, 920);
      expect(controller.logs.first.type, BeverageType.coffee);
    });

    test('Adding mineral water applies 100% hydration factor correctly', () {
      final controller = BeverageTrackerController();
      controller.addBeverage(BeverageType.mineralWater, 200, 'Şişe');
      expect(controller.consumedMl, 1000);
      expect(controller.effectiveHydrationMl, 1000);
      expect(controller.logs.first.type, BeverageType.mineralWater);
    });

    test('consumptionByType aggregates amounts by drink correctly', () {
      final controller = BeverageTrackerController();
      controller.addBeverage(BeverageType.tea, 200);
      controller.addBeverage(BeverageType.coffee, 150);

      final breakdown = controller.consumptionByType;
      expect(breakdown[BeverageType.water], 800);
      expect(breakdown[BeverageType.tea], 200);
      expect(breakdown[BeverageType.coffee], 150);
      expect(breakdown[BeverageType.mineralWater], 0);
    });

    test('selectType updates selectedType and notifies listeners', () {
      final controller = BeverageTrackerController();
      expect(controller.selectedType, BeverageType.water);
      controller.selectType(BeverageType.tea);
      expect(controller.selectedType, BeverageType.tea);
    });
  });
}
