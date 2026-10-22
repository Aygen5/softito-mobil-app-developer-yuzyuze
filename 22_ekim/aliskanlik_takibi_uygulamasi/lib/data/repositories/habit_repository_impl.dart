import 'dart:async';

import '../../core/utils/date_utils.dart';
import '../../core/utils/streak_calculator.dart';
import '../../models/habit.dart';
import '../../models/habit_completion.dart';
import '../demo/demo_data_factory.dart';
import 'habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final List<Habit> _habits;
  final List<HabitCompletion> _completions;

  final _habitsController = StreamController<List<Habit>>.broadcast();
  final _completionsController =
      StreamController<List<HabitCompletion>>.broadcast();

  HabitRepositoryImpl({
    List<Habit>? initialHabits,
    List<HabitCompletion>? initialCompletions,
  }) : _habits = initialHabits ?? DemoDataFactory.createDemoHabits(),
       _completions =
           initialCompletions ?? DemoDataFactory.createDemoCompletions() {
    _recalculateStreaks();
  }

  void _recalculateStreaks() {
    final now = DateTime.now();
    for (int i = 0; i < _habits.length; i++) {
      final h = _habits[i];
      if (h.isNotStarted) continue;
      final streak = StreakCalculator.calculateCurrentStreak(
        habit: h,
        completions: _completions,
        today: now,
      );
      _habits[i] = h.copyWith(currentStreak: streak);
    }
  }

  void _notify() {
    _habitsController.add(List.unmodifiable(_habits));
    _completionsController.add(List.unmodifiable(_completions));
  }

  @override
  List<Habit> getHabits() => List.unmodifiable(_habits);

  @override
  List<HabitCompletion> getCompletions() => List.unmodifiable(_completions);

  @override
  List<HabitCompletion> getCompletionsForDate(DateTime date) {
    final norm = AppDateUtils.normalize(date);
    return _completions
        .where((c) => AppDateUtils.isSameDay(c.date, norm))
        .toList();
  }

  @override
  Stream<List<Habit>> get habitsStream => _habitsController.stream;

  @override
  Stream<List<HabitCompletion>> get completionsStream =>
      _completionsController.stream;

  @override
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    _recalculateStreaks();
    _notify();
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final idx = _habits.indexWhere((h) => h.id == habit.id);
    if (idx != -1) {
      _habits[idx] = habit;
      _recalculateStreaks();
      _notify();
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    _completions.removeWhere((c) => c.habitId == habitId);
    _recalculateStreaks();
    _notify();
  }

  @override
  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final normDate = AppDateUtils.normalize(date);
    final isToday = AppDateUtils.isSameDay(normDate, DateTime.now());

    final compIdx = _completions.indexWhere(
      (c) => c.habitId == habitId && AppDateUtils.isSameDay(c.date, normDate),
    );

    final habitIdx = _habits.indexWhere((h) => h.id == habitId);
    if (habitIdx == -1) return;
    final habit = _habits[habitIdx];

    bool newStatus = true;

    if (compIdx != -1) {
      final existing = _completions[compIdx];
      newStatus = !existing.isCompleted;
      _completions[compIdx] = existing.copyWith(
        isCompleted: newStatus,
        value: newStatus ? habit.targetValue : 0,
      );
    } else {
      _completions.add(
        HabitCompletion(
          id: 'comp_${habitId}_${normDate.millisecondsSinceEpoch}',
          habitId: habitId,
          date: normDate,
          value: habit.targetValue,
          isCompleted: true,
        ),
      );
      newStatus = true;
    }

    if (isToday) {
      _habits[habitIdx] = habit.copyWith(
        isCompletedToday: newStatus,
        todayProgress: newStatus ? habit.targetValue : 0,
        isNotStarted: false,
      );
    }

    _recalculateStreaks();
    _notify();
  }

  @override
  Future<void> updateHabitProgress(
    String habitId,
    DateTime date,
    double value,
  ) async {
    final normDate = AppDateUtils.normalize(date);
    final isToday = AppDateUtils.isSameDay(normDate, DateTime.now());

    final habitIdx = _habits.indexWhere((h) => h.id == habitId);
    if (habitIdx == -1) return;
    final habit = _habits[habitIdx];

    final isComplete = value >= habit.targetValue;

    final compIdx = _completions.indexWhere(
      (c) => c.habitId == habitId && AppDateUtils.isSameDay(c.date, normDate),
    );

    if (compIdx != -1) {
      _completions[compIdx] = _completions[compIdx].copyWith(
        value: value,
        isCompleted: isComplete,
      );
    } else {
      _completions.add(
        HabitCompletion(
          id: 'comp_${habitId}_${normDate.millisecondsSinceEpoch}',
          habitId: habitId,
          date: normDate,
          value: value,
          isCompleted: isComplete,
        ),
      );
    }

    if (isToday) {
      _habits[habitIdx] = habit.copyWith(
        todayProgress: value,
        isCompletedToday: isComplete,
        isNotStarted: false,
      );
    }

    _recalculateStreaks();
    _notify();
  }
}
