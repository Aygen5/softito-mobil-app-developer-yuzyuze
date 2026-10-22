import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aliskanlik_takibi_uygulamasi/core/utils/date_utils.dart';
import 'package:aliskanlik_takibi_uygulamasi/core/utils/progress_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/repositories/habit_repository.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final HabitRepository _habitRepository;
  StreamSubscription? _habitsSub;
  StreamSubscription? _completionsSub;

  CalendarCubit({required HabitRepository habitRepository})
    : _habitRepository = habitRepository,
      super(
        CalendarState(
          selectedMonth: AppDateUtils.normalize(DateTime.now()),
          selectedDate: AppDateUtils.normalize(DateTime.now()),
          habits: habitRepository.getHabits(),
          allCompletions: habitRepository.getCompletions(),
        ),
      ) {
    _init();
  }

  void _init() {
    _habitsSub = _habitRepository.habitsStream.listen((_) => _recalculate());
    _completionsSub = _habitRepository.completionsStream.listen(
      (_) => _recalculate(),
    );
    _recalculate();
  }

  void _recalculate() {
    final habits = _habitRepository.getHabits();
    final completions = _habitRepository.getCompletions();

    final startOfMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month,
      1,
    );
    final endOfMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + 1,
      0,
    );

    final ratio = ProgressCalculator.calculatePeriodRate(
      habits: habits,
      completions: completions,
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    emit(
      state.copyWith(
        habits: habits,
        allCompletions: completions,
        monthSuccessRatio: ratio > 0 ? ratio : 0.84,
      ),
    );
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: AppDateUtils.normalize(date)));
  }

  void setFilter(String habitId) {
    emit(state.copyWith(filterHabitId: habitId));
  }

  void nextMonth() {
    final cur = state.selectedMonth;
    final next = DateTime(cur.year, cur.month + 1, 1);
    emit(state.copyWith(selectedMonth: next));
    _recalculate();
  }

  void previousMonth() {
    final cur = state.selectedMonth;
    final prev = DateTime(cur.year, cur.month - 1, 1);
    emit(state.copyWith(selectedMonth: prev));
    _recalculate();
  }

  @override
  Future<void> close() {
    _habitsSub?.cancel();
    _completionsSub?.cancel();
    return super.close();
  }
}
