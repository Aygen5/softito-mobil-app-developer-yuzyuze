import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aliskanlik_takibi_uygulamasi/data/repositories/habit_repository.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/repositories/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository statisticsRepository;
  final HabitRepository habitRepository;
  StreamSubscription? _habitsSub;
  StreamSubscription? _completionsSub;

  StatisticsCubit({
    required this.statisticsRepository,
    required this.habitRepository,
  }) : super(const StatisticsState()) {
    _refresh();
    _habitsSub = habitRepository.habitsStream.listen((_) => _refresh());
    _completionsSub = habitRepository.completionsStream.listen(
      (_) => _refresh(),
    );
  }

  void _refresh() {
    emit(
      state.copyWith(
        totalCompletions: statisticsRepository.getTotalCompletions(),
        currentStreak: statisticsRepository.getCurrentBestStreak(),
        longestStreak: statisticsRepository.getLongestStreak(),
        consistencyRate: statisticsRepository.getConsistencyRate(),
        weeklyActivity: statisticsRepository.getWeeklyActivity(),
        habitRates: statisticsRepository.getHabitRates(),
        achievements: statisticsRepository.getAchievements(),
        mostConsistentHabit: statisticsRepository.getMostConsistentHabit(),
        nextFocusHabit: statisticsRepository.getNextFocusHabit(),
      ),
    );
  }

  void toggleTimeMode(bool isWeekly) {
    emit(state.copyWith(isWeeklyMode: isWeekly));
  }

  @override
  Future<void> close() {
    _habitsSub?.cancel();
    _completionsSub?.cancel();
    return super.close();
  }
}
