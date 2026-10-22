import 'package:aliskanlik_takibi_uygulamasi/models/daily_progress.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';

class HomeState {
  final List<Habit> habits;
  final DailyProgress dailyProgress;
  final DateTime selectedDate;
  final String currentQuote;
  final double waterConsumed;
  final double waterTarget;
  final bool isLoading;

  const HomeState({
    required this.habits,
    required this.dailyProgress,
    required this.selectedDate,
    required this.currentQuote,
    this.waterConsumed = 2500,
    this.waterTarget = 3000,
    this.isLoading = false,
  });

  HomeState copyWith({
    List<Habit>? habits,
    DailyProgress? dailyProgress,
    DateTime? selectedDate,
    String? currentQuote,
    double? waterConsumed,
    double? waterTarget,
    bool? isLoading,
  }) {
    return HomeState(
      habits: habits ?? this.habits,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      selectedDate: selectedDate ?? this.selectedDate,
      currentQuote: currentQuote ?? this.currentQuote,
      waterConsumed: waterConsumed ?? this.waterConsumed,
      waterTarget: waterTarget ?? this.waterTarget,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
