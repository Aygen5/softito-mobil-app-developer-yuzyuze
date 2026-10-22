import 'package:flutter_test/flutter_test.dart';
import 'package:aliskanlik_takibi_uygulamasi/core/utils/streak_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/demo/demo_habits.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/demo/demo_history.dart';

void main() {
  test('Demo verileri ve streak hesaplama testi', () {
    final habits = DemoHabits.initialHabits;
    final completions = DemoHistory.generateCompletions(DateTime.now());

    expect(habits.length, 5);
    expect(completions.isNotEmpty, true);

    final stepHabit = habits.firstWhere((h) => h.id == 'step_10k');
    final streak = StreakCalculator.calculateCurrentStreak(
      habit: stepHabit,
      completions: completions,
      today: DateTime.now(),
    );

    expect(streak, greaterThanOrEqualTo(29));
  });
}
