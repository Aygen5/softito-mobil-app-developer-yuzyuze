import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_log_model.dart';

void main() {
  group('WaterTracker Backward Compatibility Tests', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial water logs should contain default seed logs', () {
      expect(controller.logs.isNotEmpty, isTrue);
      expect(controller.consumedMl, greaterThan(0));
    });

    test('addWater should increase consumed water and record a WaterLogModel', () {
      final initialConsumed = controller.consumedMl;
      controller.addWater(250, 'Bardak');

      expect(controller.consumedMl, equals(initialConsumed + 250));
      expect(controller.logs.first, isA<WaterLogModel>());
      expect(controller.logs.first.amountMl, equals(250));
      expect(controller.logs.first.containerType, equals('Bardak'));
    });

    test('removeLog should remove the target log and update total', () {
      controller.addWater(500, 'Matara');
      final addedLogId = controller.logs.first.id;
      final beforeDelete = controller.consumedMl;

      controller.removeLog(addedLogId);
      expect(controller.consumedMl, equals(beforeDelete - 500));
    });

    test('resetToday should clear all logs', () {
      controller.resetToday();
      expect(controller.logs.isEmpty, isTrue);
      expect(controller.consumedMl, equals(0));
    });
  });
}
