import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController extends ChangeNotifier {
  int _dailyCalorieGoal = 600;
  final List<WorkoutModel> _workouts = [];

  WorkoutController() {
    _initDefaults();
  }

  void _initDefaults() {
    final now = DateTime.now();
    _workouts.addAll([
      WorkoutModel(
        id: 'w1',
        type: WorkoutType.strength,
        durationMinutes: 45,
        caloriesBurned: 315,
        timestamp: now.subtract(const Duration(hours: 4)),
      ),
    ]);
  }

  int get dailyCalorieGoal => _dailyCalorieGoal;
  List<WorkoutModel> get workouts => List.unmodifiable(_workouts);

  int get totalBurnedCalories =>
      _workouts.fold<int>(0, (sum, w) => sum + w.caloriesBurned);

  int get totalDurationMinutes =>
      _workouts.fold<int>(0, (sum, w) => sum + w.durationMinutes);

  double get progressRatio {
    if (_dailyCalorieGoal <= 0) return 0.0;
    final ratio = totalBurnedCalories / _dailyCalorieGoal;
    return ratio.clamp(0.0, 1.0);
  }

  int _workoutCounter = 0;

  void addWorkout(WorkoutType type, int durationMinutes, [int? calories]) {
    final calculatedCal = calories ?? (type.defaultCalPerMin * durationMinutes);
    final workout = WorkoutModel(
      id: '${DateTime.now().microsecondsSinceEpoch}_${_workoutCounter++}',
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: calculatedCal,
      timestamp: DateTime.now(),
    );
    _workouts.insert(0, workout);
    notifyListeners();
  }

  void removeWorkout(String id) {
    _workouts.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  void setCalorieGoal(int goal) {
    if (goal > 0) {
      _dailyCalorieGoal = goal;
      notifyListeners();
    }
  }

  void resetToday() {
    _workouts.clear();
    notifyListeners();
  }
}
