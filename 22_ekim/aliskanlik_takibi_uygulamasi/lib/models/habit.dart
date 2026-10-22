import 'habit_category.dart';

class Habit {
  final String id;
  final String title;
  final HabitCategory category;
  final int iconCodePoint;
  final int colorValue;
  final double targetValue;
  final String targetUnit;
  final Set<int> scheduledDays; // 1: Pzt ... 7: Paz
  final bool reminderEnabled;
  final String? reminderTime; // '08:30'
  final int? challengeTotalDays; // örn: 30
  final int? challengeCurrentDay; // örn: 14
  final DateTime createdAt;
  final bool isCompletedToday;
  final double todayProgress;
  final int currentStreak;
  final bool isNotStarted;

  const Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.iconCodePoint,
    required this.colorValue,
    required this.targetValue,
    required this.targetUnit,
    required this.scheduledDays,
    this.reminderEnabled = false,
    this.reminderTime,
    this.challengeTotalDays,
    this.challengeCurrentDay,
    required this.createdAt,
    this.isCompletedToday = false,
    this.todayProgress = 0,
    this.currentStreak = 0,
    this.isNotStarted = false,
  });

  double get completionRatio {
    if (isCompletedToday) return 1.0;
    if (isNotStarted) return 0.0;
    if (challengeTotalDays != null && challengeCurrentDay != null) {
      return (challengeCurrentDay! / challengeTotalDays!).clamp(0.0, 1.0);
    }
    if (targetValue > 0) {
      return (todayProgress / targetValue).clamp(0.0, 1.0);
    }
    return 0.0;
  }

  Habit copyWith({
    String? id,
    String? title,
    HabitCategory? category,
    int? iconCodePoint,
    int? colorValue,
    double? targetValue,
    String? targetUnit,
    Set<int>? scheduledDays,
    bool? reminderEnabled,
    String? reminderTime,
    int? challengeTotalDays,
    int? challengeCurrentDay,
    DateTime? createdAt,
    bool? isCompletedToday,
    double? todayProgress,
    int? currentStreak,
    bool? isNotStarted,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      challengeTotalDays: challengeTotalDays ?? this.challengeTotalDays,
      challengeCurrentDay: challengeCurrentDay ?? this.challengeCurrentDay,
      createdAt: createdAt ?? this.createdAt,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      todayProgress: todayProgress ?? this.todayProgress,
      currentStreak: currentStreak ?? this.currentStreak,
      isNotStarted: isNotStarted ?? this.isNotStarted,
    );
  }
}
