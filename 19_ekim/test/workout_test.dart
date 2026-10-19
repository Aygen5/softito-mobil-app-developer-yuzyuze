import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';
import 'package:susadim/features/workout/models/workout_model.dart';

void main() {
  group('WorkoutController Tests', () {
    test('Initial calories and minutes are computed correctly', () {
      final controller = WorkoutController();
      expect(controller.totalBurnedCalories, 315);
      expect(controller.totalDurationMinutes, 45);
      expect(controller.dailyCalorieGoal, 600);
      expect(controller.progressRatio, closeTo(315 / 600, 0.01));
    });

    test('addWorkout calculates calories from defaultCalPerMin if not given', () {
      final controller = WorkoutController();
      // Cardio defaultCalPerMin = 10, 30 min => 300 kcal
      controller.addWorkout(WorkoutType.cardio, 30);
      expect(controller.totalBurnedCalories, 615);
      expect(controller.totalDurationMinutes, 75);
      expect(controller.workouts.first.type, WorkoutType.cardio);
    });

    test('removeWorkout removes specified workout', () {
      final controller = WorkoutController();
      controller.removeWorkout('w1');
      expect(controller.totalBurnedCalories, 0);
      expect(controller.totalDurationMinutes, 0);
      expect(controller.workouts.isEmpty, true);
    });

    test('resetToday clears all workouts', () {
      final controller = WorkoutController();
      controller.resetToday();
      expect(controller.totalBurnedCalories, 0);
      expect(controller.workouts.isEmpty, true);
      expect(controller.progressRatio, 0.0);
    });
  });
}
