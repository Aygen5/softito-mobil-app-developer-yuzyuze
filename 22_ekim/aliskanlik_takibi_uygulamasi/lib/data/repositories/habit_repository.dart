import '../../models/habit.dart';
import '../../models/habit_completion.dart';

abstract class HabitRepository {
  List<Habit> getHabits();
  List<HabitCompletion> getCompletions();
  List<HabitCompletion> getCompletionsForDate(DateTime date);

  Stream<List<Habit>> get habitsStream;
  Stream<List<HabitCompletion>> get completionsStream;

  Future<void> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(String habitId);
  Future<void> toggleHabitCompletion(String habitId, DateTime date);
  Future<void> updateHabitProgress(String habitId, DateTime date, double value);
  Future<void> startHabit(String habitId);
}
