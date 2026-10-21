import 'package:intl/intl.dart';

/// Türkçe tarih ve zaman biçimlendirme araçları.
abstract final class DateFormatter {
  static const String _locale = 'tr_TR';

  /// Örnek: "21 Ekim 2026"
  static String formatFullDate(DateTime date) {
    try {
      return DateFormat('d MMMM yyyy', _locale).format(date);
    } catch (_) {
      return DateFormat('d MMMM yyyy').format(date);
    }
  }

  /// formatFullDate için takma ad
  static String formatDateTurkish(DateTime date) => formatFullDate(date);

  /// Örnek: "21 Ekim 2026, Çarşamba"
  static String formatWithDay(DateTime date) {
    try {
      return DateFormat('d MMMM yyyy, EEEE', _locale).format(date);
    } catch (_) {
      return DateFormat('d MMMM yyyy, EEEE').format(date);
    }
  }

  /// Örnek: "21.10.2026"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  /// Örnek: "21.10.2026 14:30"
  static String formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  /// İki tarihin aynı takvim gününe ait olup olmadığını kontrol eder.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
