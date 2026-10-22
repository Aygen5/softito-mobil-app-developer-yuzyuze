import '../../models/achievement.dart';
import '../../models/habit.dart';

abstract class StatisticsRepository {
  int getTotalCompletions();
  int getCurrentBestStreak();
  int getLongestStreak();
  double getConsistencyRate();
  List<double> getWeeklyActivity();
  List<double> getMonthlyActivity();
  List<Achievement> getAchievements();
  Habit? getMostConsistentHabit();
  Habit? getNextFocusHabit();
  Map<String, double> getHabitRates();
}
