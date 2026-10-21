import 'package:flutter_test/flutter_test.dart';
import 'package:staj_takip/core/utils/workday_calculator.dart';

void main() {
  group('WorkdayCalculator Tests', () {
    test('isWeekend should identify Saturday and Sunday correctly', () {
      final saturday = DateTime(2026, 10, 24);
      final sunday = DateTime(2026, 10, 25);
      final wednesday = DateTime(2026, 10, 21);

      expect(WorkdayCalculator.isWeekend(saturday), isTrue);
      expect(WorkdayCalculator.isWeekend(sunday), isTrue);
      expect(WorkdayCalculator.isWeekend(wednesday), isFalse);
    });

    test('calculateProgressRatio should clamp between 0.0 and 1.0', () {
      expect(
        WorkdayCalculator.calculateProgressRatio(
          completedDays: 0,
          requiredDays: 30,
        ),
        0.0,
      );
      expect(
        WorkdayCalculator.calculateProgressRatio(
          completedDays: 15,
          requiredDays: 30,
        ),
        0.5,
      );
      expect(
        WorkdayCalculator.calculateProgressRatio(
          completedDays: 30,
          requiredDays: 30,
        ),
        1.0,
      );
      expect(
        WorkdayCalculator.calculateProgressRatio(
          completedDays: 45,
          requiredDays: 30,
        ),
        1.0,
      );
      expect(
        WorkdayCalculator.calculateProgressRatio(
          completedDays: 10,
          requiredDays: 0,
        ),
        0.0,
      );
    });

    test('calculateProgressPercentage should return correct percentage', () {
      expect(
        WorkdayCalculator.calculateProgressPercentage(
          completedDays: 12,
          requiredDays: 30,
        ),
        40,
      );
      expect(
        WorkdayCalculator.calculateProgressPercentage(
          completedDays: 30,
          requiredDays: 30,
        ),
        100,
      );
      expect(
        WorkdayCalculator.calculateProgressPercentage(
          completedDays: 35,
          requiredDays: 30,
        ),
        100,
      );
    });

    test('countUniqueDays should deduplicate dates', () {
      final dates = [
        DateTime(2026, 10, 20, 9, 0),
        DateTime(2026, 10, 20, 17, 30),
        DateTime(2026, 10, 21, 10, 0),
      ];

      expect(WorkdayCalculator.countUniqueDays(dates), 2);
    });
  });
}
