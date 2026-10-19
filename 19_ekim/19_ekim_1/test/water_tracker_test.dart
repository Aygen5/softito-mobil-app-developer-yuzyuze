import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

void main() {
  group('WaterTrackerController Tests', () {
    test('Initial consumption calculation works properly', () {
      final controller = WaterTrackerController();
      expect(controller.consumedMl, 800); // 300 + 500
      expect(controller.dailyGoalMl, 2500);
      expect(controller.progressRatio, closeTo(800 / 2500, 0.01));
    });

    test('addWater increases consumed ml and inserts log at the top', () {
      final controller = WaterTrackerController();
      controller.addWater(250, 'Bardak');
      expect(controller.consumedMl, 1050);
      expect(controller.logs.first.amountMl, 250);
      expect(controller.logs.first.containerType, 'Bardak');
    });

    test('removeLog removes specified log', () {
      final controller = WaterTrackerController();
      controller.removeLog('1');
      expect(controller.consumedMl, 500);
    });

    test('resetToday clears all water logs', () {
      final controller = WaterTrackerController();
      controller.resetToday();
      expect(controller.consumedMl, 0);
      expect(controller.logs.isEmpty, true);
      expect(controller.progressRatio, 0.0);
    });
  });
}
