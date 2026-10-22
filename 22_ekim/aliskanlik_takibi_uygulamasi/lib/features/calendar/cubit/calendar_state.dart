import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit_completion.dart';

class CalendarState {
  final DateTime selectedMonth;
  final DateTime selectedDate;
  final String filterHabitId; // 'all' or habitId
  final List<Habit> habits;
  final List<HabitCompletion> allCompletions;
  final double monthSuccessRatio;

  const CalendarState({
    required this.selectedMonth,
    required this.selectedDate,
    this.filterHabitId = 'all',
    required this.habits,
    required this.allCompletions,
    this.monthSuccessRatio = 0.84,
  });

  CalendarState copyWith({
    DateTime? selectedMonth,
    DateTime? selectedDate,
    String? filterHabitId,
    List<Habit>? habits,
    List<HabitCompletion>? allCompletions,
    double? monthSuccessRatio,
  }) {
    return CalendarState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      filterHabitId: filterHabitId ?? this.filterHabitId,
      habits: habits ?? this.habits,
      allCompletions: allCompletions ?? this.allCompletions,
      monthSuccessRatio: monthSuccessRatio ?? this.monthSuccessRatio,
    );
  }
}
