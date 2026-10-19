import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/models/workout_model.dart';

void main() {
  group('WorkoutController Tests', () {
    late WorkoutController controller;

    setUp(() {
      controller = WorkoutController();
      controller.resetToday(); // Temiz test ortamı
    });

    tearDown(() {
      controller.dispose();
    });

    test('addWorkout with default cal/min correctly computes calories', () {
      // Cardio default: 10 cal/min -> 30 min = 300 kcal
      controller.addWorkout(WorkoutType.cardio, 30);
      expect(controller.workouts.length, equals(1));
      expect(controller.totalDurationMinutes, equals(30));
      expect(controller.totalBurnedCalories, equals(300));
    });

    test('addWorkout with custom calories overrides default', () {
      controller.addWorkout(WorkoutType.strength, 45, 400);
      expect(controller.totalBurnedCalories, equals(400));
      expect(controller.totalDurationMinutes, equals(45));
    });

    test('removeWorkout removes entry and updates total stats', () {
      controller.addWorkout(WorkoutType.hiit, 20); // 20 * 12 = 240
      controller.addWorkout(WorkoutType.cycling, 30); // 30 * 8 = 240
      expect(controller.totalBurnedCalories, equals(480));

      final firstId = controller.workouts.first.id;
      controller.removeWorkout(firstId);

      expect(controller.workouts.length, equals(1));
      expect(controller.totalBurnedCalories, equals(240));
    });

    test('progressRatio reflects daily calorie goal accurately', () {
      controller.setCalorieGoal(500);
      controller.addWorkout(WorkoutType.cardio, 25); // 250 kcal
      expect(controller.progressRatio, equals(0.5));
    });
  });
}
