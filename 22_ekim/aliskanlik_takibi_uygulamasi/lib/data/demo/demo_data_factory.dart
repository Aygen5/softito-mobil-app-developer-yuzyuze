import '../../models/habit.dart';
import '../../models/habit_completion.dart';
import 'demo_habits.dart';
import 'demo_history.dart';

class DemoDataFactory {
  static List<Habit> createDemoHabits() {
    return List<Habit>.from(DemoHabits.initialHabits);
  }

  static List<HabitCompletion> createDemoCompletions([
    DateTime? referenceDate,
  ]) {
    return DemoHistory.generateCompletions(referenceDate ?? DateTime.now());
  }
}
