class AppDateUtils {
  AppDateUtils._();

  // Tarihi Türkçe formatta göster (20.10.2026)
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  // Tarih ve Saati Türkçe formatta göster (20.10.2026 14:00)
  static String formatDateTime(DateTime dateTime) {
    final dateStr = formatDate(dateTime);
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  // Sadece Saati göster (14:00)
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Ay ve gün gösterimi (örn: 20 Ekim)
  static String formatDayMonth(DateTime date) {
    const months = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month]}';
  }

  // ISO string veya YYYY-MM-DD string'inden DateTime ayrıştırma
  static DateTime? tryParseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  // İki tarih aralığının çakışıp çakışmadığını kontrol et
  // Bitişik saat kuralı: Bir rezervasyonun bitişi diğerinin başlangıcına eşitse ÇAKIŞMA DEĞİLDİR (izin verilir)
  static bool hasDateOverlap({
    required DateTime start1,
    required DateTime end1,
    required DateTime start2,
    required DateTime end2,
  }) {
    // start1 < end2 && end1 > start2
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  // Geçmiş tarih kontrolü: Tarih bugünün başlangıcından önce mi?
  static bool isPastDate(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final targetStart = DateTime(date.year, date.month, date.day);
    return targetStart.isBefore(todayStart);
  }

  // İki tarihin aynı takvim günü olup olmadığı
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Belirli bir günün belirli bir tarih aralığının içinde olup olmadığı (gün bazında)
  static bool isDayWithinRange(DateTime day, DateTime start, DateTime end) {
    final dayDate = DateTime(day.year, day.month, day.day);
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    return (dayDate.isAtSameMomentAs(startDate) || dayDate.isAfter(startDate)) &&
        (dayDate.isAtSameMomentAs(endDate) || dayDate.isBefore(endDate));
  }

  // Toplam kiralama süresi (gün ve saat olarak)
  static ({int days, int hours, double totalDays}) calculateDuration(
    DateTime start,
    DateTime end,
  ) {
    final diff = end.difference(start);
    if (diff.isNegative) {
      return (days: 0, hours: 0, totalDays: 0.0);
    }

    final totalHours = diff.inHours;
    final days = totalHours ~/ 24;
    final remainingHours = totalHours % 24;
    final totalDays = diff.inMinutes / (24 * 60);

    return (days: days, hours: remainingHours, totalDays: totalDays);
  }
}
