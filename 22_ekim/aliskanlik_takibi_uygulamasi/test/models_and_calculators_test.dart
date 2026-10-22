import 'package:flutter_test/flutter_test.dart';
import 'package:aliskanlik_takibi_uygulamasi/core/utils/streak_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/core/utils/progress_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/core/utils/achievement_calculator.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/demo/demo_habits.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/demo/demo_history.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit_category.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit_completion.dart';

void main() {
  group('Hesaplayıcılar ve İş Kuralları Testleri', () {
    final fixedDate = DateTime(2026, 10, 22);

    test('Demo verileri eksiksiz ve 5 başlangıç alışkanlığı içerir', () {
      final habits = DemoHabits.initialHabits;
      expect(habits.length, 5);

      final stepHabit = habits.firstWhere((h) => h.id == 'step_10k');
      final smokeHabit = habits.firstWhere((h) => h.id == 'smoke_free');
      final gymHabit = habits.firstWhere((h) => h.id == 'gym_workout');
      final bookHabit = habits.firstWhere((h) => h.id == 'read_100p');
      final waterHabit = habits.firstWhere((h) => h.id == 'water_3l');

      expect(stepHabit.title, 'Günde 10.000 Adım');
      expect(smokeHabit.title, 'Sigarasız Yaşam');
      expect(gymHabit.title, 'Spor Salonuna Git');
      expect(bookHabit.title, 'Her Gün 100 Sayfa Oku');
      expect(waterHabit.title, 'Günde 3 Litre Su');
    });

    test('Günde 10.000 Adım alışkanlığı 30 günlük seriye sahiptir', () {
      final habits = DemoHabits.initialHabits;
      final completions = DemoHistory.generateCompletions(fixedDate);
      final stepHabit = habits.firstWhere((h) => h.id == 'step_10k');

      final currentStreak = StreakCalculator.calculateCurrentStreak(
        habit: stepHabit,
        completions: completions,
        today: fixedDate,
      );
      final longestStreak = StreakCalculator.calculateLongestStreak(
        habit: stepHabit,
        completions: completions,
      );

      expect(currentStreak, greaterThanOrEqualTo(29));
      expect(longestStreak, greaterThanOrEqualTo(29));
    });

    test('Planlanmamış günler streak serisini bozmaz', () {
      // Sadece Pazartesi (1), Çarşamba (3), Cuma (5) planlı bir alışkanlık
      final habit = Habit(
        id: 'mwf_habit',
        title: 'Özel Program',
        category: HabitCategory.sports,
        iconCodePoint: 0,
        colorValue: 0xFF87966A,
        targetValue: 1,
        targetUnit: 'Kez',
        scheduledDays: const {1, 3, 5},
        createdAt: DateTime(2026, 10, 1),
      );

      // 19 Ekim 2026 Pazartesi, 21 Ekim Çarşamba tamamlanmış, Salı ve Perşembe planlı değil
      final List<HabitCompletion> completions = [
        HabitCompletion(
          id: 'c1',
          habitId: 'mwf_habit',
          date: DateTime(2026, 10, 19),
          value: 1,
          isCompleted: true,
        ),
        HabitCompletion(
          id: 'c2',
          habitId: 'mwf_habit',
          date: DateTime(2026, 10, 21),
          value: 1,
          isCompleted: true,
        ),
      ];

      final streak = StreakCalculator.calculateCurrentStreak(
        habit: habit,
        completions: completions,
        today: DateTime(2026, 10, 21),
      );

      expect(streak, 2);
    });

    test('Günlük ve dönemsel ilerleme doğru hesaplanır', () {
      final habits = DemoHabits.initialHabits;
      final completions = DemoHistory.generateCompletions(fixedDate);

      final dailyProgress = ProgressCalculator.calculateDailyProgress(
        habits: habits,
        completions: completions,
        date: fixedDate,
      );

      expect(dailyProgress.totalHabits, greaterThan(0));
      expect(dailyProgress.completedHabits, greaterThanOrEqualTo(0));
      expect(dailyProgress.percentage, inInclusiveRange(0, 100));
      expect(dailyProgress.ratio, inInclusiveRange(0.0, 1.0));

      final periodRate = ProgressCalculator.calculatePeriodRate(
        habits: habits,
        completions: completions,
        startDate: fixedDate.subtract(const Duration(days: 7)),
        endDate: fixedDate,
      );

      expect(periodRate, greaterThan(0.0));
      expect(periodRate, lessThanOrEqualTo(1.0));
    });

    test('Rozet kazanma koşulları değerlendirilir', () {
      final habits = DemoHabits.initialHabits;
      final completions = DemoHistory.generateCompletions(fixedDate);

      final achievements = AchievementCalculator.evaluateAchievements(
        habits: habits,
        completions: completions,
      );

      expect(achievements.length, 10);

      // İlk Adım rozeti kesinlikle açık olmalıdır
      final firstStep = achievements.firstWhere((a) => a.id == 'ilk_adim');
      expect(firstStep.isUnlocked, true);

      // 7 Günlük Seri rozeti açık olmalıdır
      final streak7 = achievements.firstWhere((a) => a.id == 'seri_7');
      expect(streak7.isUnlocked, true);

      // 30 Gün rozeti açık olmalıdır
      final streak30 = achievements.firstWhere((a) => a.id == 'istikrar_30');
      expect(streak30.isUnlocked, true);

      // Henüz kazanılmamış kilitli rozetler bulunmalıdır
      final lockedBadges = achievements.where((a) => !a.isUnlocked).toList();
      expect(
        lockedBadges.isNotEmpty,
        true,
        reason: 'Kazanılmamış rozetler kilitli kalmalıdır',
      );
    });
  });
}
