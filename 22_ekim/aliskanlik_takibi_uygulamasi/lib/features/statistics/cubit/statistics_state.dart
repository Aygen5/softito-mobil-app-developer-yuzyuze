import 'package:aliskanlik_takibi_uygulamasi/models/achievement.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';

class StatisticsState {
  final bool isWeeklyMode;
  final int totalCompletions;
  final int currentStreak;
  final int longestStreak;
  final double consistencyRate;
  final List<double> weeklyActivity;
  final Map<String, double> habitRates;
  final List<Achievement> achievements;
  final Habit? mostConsistentHabit;
  final Habit? nextFocusHabit;

  const StatisticsState({
    this.isWeeklyMode = true,
    this.totalCompletions = 142,
    this.currentStreak = 30,
    this.longestStreak = 45,
    this.consistencyRate = 0.84,
    this.weeklyActivity = const [4, 5, 4, 3, 5, 4, 3],
    this.habitRates = const {},
    this.achievements = const [],
    this.mostConsistentHabit,
    this.nextFocusHabit,
  });

  int get unlockedBadgesCount => achievements.where((a) => a.isUnlocked).length;

  StatisticsState copyWith({
    bool? isWeeklyMode,
    int? totalCompletions,
    int? currentStreak,
    int? longestStreak,
    double? consistencyRate,
    List<double>? weeklyActivity,
    Map<String, double>? habitRates,
    List<Achievement>? achievements,
    Habit? mostConsistentHabit,
    Habit? nextFocusHabit,
  }) {
    return StatisticsState(
      isWeeklyMode: isWeeklyMode ?? this.isWeeklyMode,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      consistencyRate: consistencyRate ?? this.consistencyRate,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      habitRates: habitRates ?? this.habitRates,
      achievements: achievements ?? this.achievements,
      mostConsistentHabit: mostConsistentHabit ?? this.mostConsistentHabit,
      nextFocusHabit: nextFocusHabit ?? this.nextFocusHabit,
    );
  }
}
