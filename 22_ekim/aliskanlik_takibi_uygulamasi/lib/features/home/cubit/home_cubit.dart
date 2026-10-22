import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aliskanlik_takibi_uygulamasi/core/utils/progress_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/repositories/habit_repository.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HabitRepository _habitRepository;
  StreamSubscription? _habitsSub;
  StreamSubscription? _completionsSub;

  static const List<String> quotes = [
    '“Büyük değişimler, küçük adımların birikimidir.”',
    '“Kendine ayırdığın her sessiz an, ruhuna kök salar.”',
    '“Süreklilik, mükemmellikten daha değerlidir.”',
    '“Bugün attığın tohum, yarının sığınağıdır.”',
    '“Nefesine ve ritmine odaklan, her adım bir zaferdir.”',
  ];

  HomeCubit({required HabitRepository habitRepository})
    : _habitRepository = habitRepository,
      super(
        HomeState(
          habits: habitRepository.getHabits(),
          dailyProgress: ProgressCalculator.calculateDailyProgress(
            habits: habitRepository.getHabits(),
            completions: habitRepository.getCompletions(),
            date: DateTime.now(),
          ),
          selectedDate: DateTime.now(),
          currentQuote: quotes[0],
        ),
      ) {
    _initSubscriptions();
  }

  void _initSubscriptions() {
    _habitsSub = _habitRepository.habitsStream.listen((habits) {
      _refresh();
    });
    _completionsSub = _habitRepository.completionsStream.listen((completions) {
      _refresh();
    });
  }

  void _refresh() {
    final habits = _habitRepository.getHabits();
    final completions = _habitRepository.getCompletions();
    final progress = ProgressCalculator.calculateDailyProgress(
      habits: habits,
      completions: completions,
      date: state.selectedDate,
    );

    // Su miktarını bul
    double water = 2500;
    final waterHabit = habits.where((h) => h.id == 'water_3l').firstOrNull;
    if (waterHabit != null) {
      water = waterHabit.todayProgress;
    }

    emit(
      state.copyWith(
        habits: habits,
        dailyProgress: progress,
        waterConsumed: water,
      ),
    );
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    _refresh();
  }

  Future<void> toggleHabit(String habitId) async {
    await _habitRepository.toggleHabitCompletion(habitId, state.selectedDate);
  }

  Future<void> startHabit(String habitId) async {
    await _habitRepository.startHabit(habitId);
  }

  Future<void> addWaterGlass() async {
    await addWater(250);
  }

  Future<void> addWater(double amount) async {
    final newAmount = (state.waterConsumed + amount).clamp(0.0, 3000.0);
    await _habitRepository.updateHabitProgress(
      'water_3l',
      state.selectedDate,
      newAmount,
    );
  }

  Future<void> addReadPages(double pages) async {
    final readHabit = state.habits
        .where((h) => h.id == 'read_100p')
        .firstOrNull;
    if (readHabit != null) {
      final newTotal = (readHabit.todayProgress + pages).clamp(
        0.0,
        readHabit.targetValue,
      );
      await _habitRepository.updateHabitProgress(
        'read_100p',
        state.selectedDate,
        newTotal,
      );
    }
  }

  void cycleQuote() {
    final currentIdx = quotes.indexOf(state.currentQuote);
    final nextIdx = (currentIdx + 1) % quotes.length;
    emit(state.copyWith(currentQuote: quotes[nextIdx]));
  }

  @override
  Future<void> close() {
    _habitsSub?.cancel();
    _completionsSub?.cancel();
    return super.close();
  }
}
