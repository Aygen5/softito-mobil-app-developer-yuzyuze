import '../../models/habit.dart';
import '../../models/habit_completion.dart';
import 'date_utils.dart';

abstract class StreakCalculator {
  /// Bir alışkanlığın güncel serisini hesaplar.
  static int calculateCurrentStreak({
    required Habit habit,
    required List<HabitCompletion> completions,
    required DateTime today,
  }) {
    if (habit.isNotStarted) return 0;

    final normToday = AppDateUtils.normalize(today);
    final completionMap = <DateTime, HabitCompletion>{};
    for (final c in completions) {
      if (c.habitId == habit.id) {
        completionMap[AppDateUtils.normalize(c.date)] = c;
      }
    }

    int streak = 0;
    DateTime checkDate = normToday;

    // Bugün planlı mı?
    final bool isTodayScheduled = habit.scheduledDays.contains(
      normToday.weekday,
    );
    final HabitCompletion? todayComp = completionMap[normToday];
    final bool isTodayCompleted = todayComp != null && todayComp.isCompleted;

    if (isTodayScheduled && isTodayCompleted) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      // Bugün henüz tamamlanmamışsa seriyi kırma; dünden geriye doğru saymaya başla
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    final normCreated = AppDateUtils.normalize(habit.createdAt);

    // Geriye doğru planlı günleri tara
    while (checkDate.isAfter(normCreated) ||
        checkDate.isAtSameMomentAs(normCreated)) {
      final bool isScheduled = habit.scheduledDays.contains(checkDate.weekday);
      if (!isScheduled) {
        // Planlanmamış gün seriyi bozmaz, atla
        checkDate = checkDate.subtract(const Duration(days: 1));
        continue;
      }

      final HabitCompletion? comp = completionMap[checkDate];
      if (comp != null && comp.isCompleted) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        // Planlı gün tamamlanmamış -> Seri kesildi
        break;
      }
    }

    return streak;
  }

  /// Tüm geçmiş kayıtlardan en uzun seriyi (longest streak) hesaplar.
  static int calculateLongestStreak({
    required Habit habit,
    required List<HabitCompletion> completions,
  }) {
    if (completions.isEmpty) return 0;

    final completionMap = <DateTime, HabitCompletion>{};
    for (final c in completions) {
      if (c.habitId == habit.id) {
        completionMap[AppDateUtils.normalize(c.date)] = c;
      }
    }

    final dates = completionMap.keys.toList()..sort();
    if (dates.isEmpty) return 0;

    int longest = 0;
    int current = 0;

    for (final d in dates) {
      if (habit.scheduledDays.contains(d.weekday)) {
        if (completionMap[d]?.isCompleted == true) {
          current++;
          if (current > longest) longest = current;
        } else {
          current = 0;
        }
      }
    }

    return longest;
  }
}
