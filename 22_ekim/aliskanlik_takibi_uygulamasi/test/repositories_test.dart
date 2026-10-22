import 'package:flutter_test/flutter_test.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/repositories/habit_repository_impl.dart';
import 'package:aliskanlik_takibi_uygulamasi/data/repositories/statistics_repository_impl.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit_category.dart';

void main() {
  group('Repository Katmanı ve CRUD/Tamamlama Testleri', () {
    late HabitRepositoryImpl habitRepo;
    late StatisticsRepositoryImpl statsRepo;

    setUp(() {
      habitRepo = HabitRepositoryImpl();
      statsRepo = StatisticsRepositoryImpl(habitRepository: habitRepo);
    });

    test('Başlangıçta 5 demo alışkanlığı yüklenir', () {
      final habits = habitRepo.getHabits();
      expect(habits.length, 5);
    });

    test('Yeni alışkanlık ekleme ve getirme işlemi çalışır', () async {
      final newHabit = Habit(
        id: 'test_habit_1',
        title: 'Akşam Meditasyonu',
        category: HabitCategory.mindfulness,
        iconCodePoint: 0,
        colorValue: 0xFF87966A,
        targetValue: 15,
        targetUnit: 'Dakika',
        scheduledDays: const {1, 2, 3, 4, 5, 6, 7},
        createdAt: DateTime.now(),
      );

      await habitRepo.addHabit(newHabit);
      final habits = habitRepo.getHabits();
      expect(habits.length, 6);
      expect(habits.any((h) => h.id == 'test_habit_1'), true);
    });

    test('Alışkanlık silme işlemi aktif listeden kaldırır', () async {
      await habitRepo.deleteHabit('gym_workout');
      final habits = habitRepo.getHabits();
      expect(habits.any((h) => h.id == 'gym_workout'), false);
    });

    test(
      'Tamamlama işlemi (toggle) reaktif çalışır ve mükerrer oluşturmaz',
      () async {
        final today = DateTime.now();
        const habitId = 'gym_workout';

        final isInitiallyDone = habitRepo
            .getCompletionsForDate(today)
            .any((c) => c.habitId == habitId && c.isCompleted);
        expect(isInitiallyDone, false);

        // Tamamla
        await habitRepo.toggleHabitCompletion(habitId, today);
        final isDoneAfterToggle = habitRepo
            .getCompletionsForDate(today)
            .any((c) => c.habitId == habitId && c.isCompleted);
        expect(isDoneAfterToggle, true);

        // Geri al
        await habitRepo.toggleHabitCompletion(habitId, today);
        final isDoneAfterUndo = habitRepo
            .getCompletionsForDate(today)
            .any((c) => c.habitId == habitId && c.isCompleted);
        expect(isDoneAfterUndo, false);
      },
    );

    test('StatisticsRepository istatistik ve özet verileri hesaplar', () {
      final totalCompletions = statsRepo.getTotalCompletions();
      expect(totalCompletions, greaterThan(0));

      final consistencyRate = statsRepo.getConsistencyRate();
      expect(consistencyRate, greaterThanOrEqualTo(0.0));
      expect(consistencyRate, lessThanOrEqualTo(1.0));

      final weeklyActivity = statsRepo.getWeeklyActivity();
      expect(weeklyActivity.length, 7);

      final mostConsistent = statsRepo.getMostConsistentHabit();
      expect(mostConsistent, isNotNull);
      expect(mostConsistent?.id, 'step_10k');
    });
  });
}
