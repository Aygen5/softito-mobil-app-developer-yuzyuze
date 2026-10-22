import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';

class HabitsState {
  final List<Habit> habits;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const HabitsState({
    required this.habits,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  HabitsState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return HabitsState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
