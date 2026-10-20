/// ---------------------------------------------------------------------------
/// 📅 AppDateUtils — Tarih ve Saat Yardımcı Fonksiyonları
/// ---------------------------------------------------------------------------
/// Bu sınıf; Türkçe tarih biçimlendirme, geçmiş gün kontrolü ve en önemlisi
/// rezervasyonların çakışıp çakışmadığını denetleyen iş mantığını içerir.
class AppDateUtils {
  /// Nesne oluşturulmasını önlemek için private constructor
  AppDateUtils._();

  /// Tarihi Türkçe formatta gösterir (Örn: 20.10.2026)
  /// 'padLeft(2, '0')': Tek haneli ayları ve günleri (örneğin 5) '05' yapar.
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Tarih ve Saati birlikte Türkçe formatta gösterir (Örn: 20.10.2026 14:00)
  static String formatDateTime(DateTime dateTime) {
    final dateStr = formatDate(dateTime);
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  /// Sadece Saati gösterir (Örn: 14:00)
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Ay ve gün gösterimi (Örn: 20 Ekim)
  /// Kullanıcı arayüzünde özet kartlarında şık bir metin sunar.
  static String formatDayMonth(DateTime date) {
    const months = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month]}';
  }

  /// ISO 8601 string veya 'YYYY-MM-DD' formatındaki metni güvenli şekilde DateTime'a çevirir.
  /// Hata oluşursa uygulamanın çökmesini önlemek için 'try-catch' ile null döner.
  static DateTime? tryParseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // ⚔️ Rezervasyon Çakışma Kontrolü (Conflict Detection Algorithm)
  // ---------------------------------------------------------------------------
  /// İki tarih aralığının çakışıp çakışmadığını matematiksel olarak doğrular.
  ///
  /// ⭐ Bitişik Saat Kuralı (Adjacent Booking Rule):
  /// Eğer A rezervasyonu 24 Ekim saat 10:00'da bitiyorsa, B rezervasyonu 24 Ekim saat 10:00'da başlayabilir.
  /// Yani 'start1 == end2' veya 'end1 == start2' durumu bir çakışma DEĞİLDİR.
  /// Çakışma ancak ve ancak:
  /// (start1 < end2) VE (end1 > start2) durumunda gerçekleşir.
  static bool hasDateOverlap({
    required DateTime start1,
    required DateTime end1,
    required DateTime start2,
    required DateTime end2,
  }) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  /// Geçmiş Tarih Kontrolü:
  /// Kullanıcının dünden veya önceki bir günden araç kiralamasını engeller.
  /// Sadece yıl, ay ve gün bazında karşılaştırma yapılarak gün içi saat farkları elenir.
  static bool isPastDate(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final targetStart = DateTime(date.year, date.month, date.day);
    return targetStart.isBefore(todayStart);
  }

  /// İki tarihin aynı takvim gününe (saat fark etmeksizin) denk gelip gelmediği
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Belirli bir günün belirli bir tarih aralığının içinde olup olmadığı
  /// Takvimde seçili aralığı renklendirmek (aralık vurgusu) için kullanılır.
  static bool isDayWithinRange(DateTime day, DateTime start, DateTime end) {
    final dayDate = DateTime(day.year, day.month, day.day);
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    return (dayDate.isAtSameMomentAs(startDate) || dayDate.isAfter(startDate)) &&
        (dayDate.isAtSameMomentAs(endDate) || dayDate.isBefore(endDate));
  }

  // ---------------------------------------------------------------------------
  // ⏱️ Dart 3 Records (Kayıtlar) ile Süre Hesaplama
  // ---------------------------------------------------------------------------
  /// Dart 3 ile gelen 'Records' (demet/tuple) yapısı sayesinde,
  /// ayrı bir model sınıfı oluşturmadan birden fazla isimlendirilmiş değeri
  /// `({int days, int hours, double totalDays})` şeklinde tip güvenli olarak döndürebiliyoruz.
  static ({int days, int hours, double totalDays}) calculateDuration(
    DateTime start,
    DateTime end,
  ) {
    final diff = end.difference(start);
    if (diff.isNegative) {
      return (days: 0, hours: 0, totalDays: 0.0);
    }

    final totalHours = diff.inHours;
    final days = totalHours ~/ 24; // '~/' tam sayı bölmesi (integer division)
    final remainingHours = totalHours % 24; // '%' mod alma (kalan saat)
    final totalDays = diff.inMinutes / (24 * 60);

    return (days: days, hours: remainingHours, totalDays: totalDays);
  }
}

