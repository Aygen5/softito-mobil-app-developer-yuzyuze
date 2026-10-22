import '../../models/daily_progress.dart';
import '../../models/habit.dart';
import '../../models/habit_completion.dart';
import 'date_utils.dart';

abstract class ProgressCalculator {
  /// Belirli bir gün için günlük ilerleme özeti
  static DailyProgress calculateDailyProgress({
    required List<Habit> habits,
    required List<HabitCompletion> completions,
    required DateTime date,
  }) {
    final normDate = AppDateUtils.normalize(date);
    int scheduledCount = 0;
    int completedCount = 0;

    for (final habit in habits) {
      if (habit.scheduledDays.contains(normDate.weekday)) {
        scheduledCount++;
        final comp = completions.firstWhere(
          (c) =>
              c.habitId == habit.id && AppDateUtils.isSameDay(c.date, normDate),
          orElse: () => HabitCompletion(
            id: '',
            habitId: habit.id,
            date: normDate,
            value: 0,
            isCompleted: false,
          ),
        );
        if (comp.isCompleted) {
          completedCount++;
        }
      }
    }

    return DailyProgress(
      totalHabits: scheduledCount,
      completedHabits: completedCount,
    );
  }

  /// Belirli bir tarih aralığı için başarı oranı (yüzde)
  static double calculatePeriodRate({
    required List<Habit> habits,
    required List<HabitCompletion> completions,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    int totalPlannedDays = 0;
    int totalCompletedDays = 0;

    DateTime cur = AppDateUtils.normalize(startDate);
    final end = AppDateUtils.normalize(endDate);

    while (cur.isBefore(end) || cur.isAtSameMomentAs(end)) {
      for (final h in habits) {
        if (h.scheduledDays.contains(cur.weekday)) {
          totalPlannedDays++;
          final isDone = completions.any(
            (c) =>
                c.habitId == h.id &&
                AppDateUtils.isSameDay(c.date, cur) &&
                c.isCompleted,
          );
          if (isDone) totalCompletedDays++;
        }
      }
      cur = cur.add(const Duration(days: 1));
    }

    if (totalPlannedDays == 0) return 0.0;
    return totalCompletedDays / totalPlannedDays;
  }
}
