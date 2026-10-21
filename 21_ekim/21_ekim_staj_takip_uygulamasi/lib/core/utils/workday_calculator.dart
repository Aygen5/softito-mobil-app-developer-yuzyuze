/// Staj günleri, ilerleme yüzdesi ve çalışma takvimi kurallarını hesaplayan motor.
abstract final class WorkdayCalculator {
  /// Bir günün hafta sonu olup olmadığını kontrol eder (Cumartesi = 6, Pazar = 7).
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Belirtilen tarihin staj başlangıç ve bitiş sınırları içinde olup olmadığını doğrular.
  static bool isWithinInternshipPeriod({
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanStart = DateTime(startDate.year, startDate.month, startDate.day);
    final cleanEnd = DateTime(endDate.year, endDate.month, endDate.day);

    return (cleanDate.isAfter(cleanStart) ||
            cleanDate.isAtSameMomentAs(cleanStart)) &&
        (cleanDate.isBefore(cleanEnd) || cleanDate.isAtSameMomentAs(cleanEnd));
  }

  /// Tamamlanan günlerin zorunlu günlere oranını 0.0 ile 1.0 arasında güvenli şekilde hesaplar.
  /// İlerleme %100'ü (1.0) aşamaz.
  static double calculateProgressRatio({
    required int completedDays,
    required int requiredDays,
  }) {
    if (requiredDays <= 0) return 0.0;
    final ratio = completedDays / requiredDays;
    return ratio.clamp(0.0, 1.0);
  }

  /// İlerleme yüzdesini tam sayı olarak döndürür (0 - 100).
  static int calculateProgressPercentage({
    required int completedDays,
    required int requiredDays,
  }) {
    final ratio = calculateProgressRatio(
      completedDays: completedDays,
      requiredDays: requiredDays,
    );
    return (ratio * 100).round();
  }

  /// Tarih listesindeki tekil onaylı gün sayısını hesaplar (aynı güne çift sayımı önler).
  static int countUniqueDays(List<DateTime> dates) {
    final unique = <String>{};
    for (final date in dates) {
      unique.add('${date.year}-${date.month}-${date.day}');
    }
    return unique.length;
  }
}
