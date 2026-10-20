import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import 'date_utils.dart';

/// ---------------------------------------------------------------------------
/// 💰 AppPriceUtils — Ücret, İndirim ve Para Birimi Hesaplayıcı
/// ---------------------------------------------------------------------------
/// Uygulamanın en temel finansal iş kurallarını (Business Logic) içerir.
/// UI widget'ları hesaplama yapmaz; hesaplamayı buraya delege eder.
/// Bu ayrım, kodun hem test edilebilir (Unit Test) hem de temiz kalmasını sağlar.
class AppPriceUtils {
  /// Nesne üretilmesini engellemek için private constructor
  AppPriceUtils._();

  /// 'NumberFormat': 'intl' paketinden gelir.
  /// '#,##0': Binlik basamakları nokta ile ayırır (örn: 1450 -> 1.450).
  /// 'tr_TR': Türkiye standartlarına göre biçimlendirir.
  static final NumberFormat _currencyFormat = NumberFormat('#,##0', 'tr_TR');

  /// Para birimi formatla: Örn: '1.450 ₺'
  static String formatPrice(num price) {
    return '${_currencyFormat.format(price)} ${AppConstants.currencySymbol}';
  }

  /// Günlük fiyat etiket metni üret: Örn: '1.450 ₺ / gün'
  static String formatDailyPrice(num dailyPrice) {
    return '${formatPrice(dailyPrice)} / gün';
  }

  /// Saatlik fiyat etiket metni üret: Örn: '120 ₺ / saat'
  static String formatHourlyPrice(num hourlyPrice) {
    return '${formatPrice(hourlyPrice)} / saat';
  }

  // ---------------------------------------------------------------------------
  // 🧮 Kiralama Fiyat Hesaplama Algoritması
  // ---------------------------------------------------------------------------
  /// Verilen başlangıç ve bitiş tarihine göre:
  /// 1. Süreyi (gün ve saat) hesaplar.
  /// 2. Saatlik/günlük tarife kurallarını uygular (24 saatten az ise saatlik,
  ///    ancak maksimum 1 gün ücreti tavanı uygulanır; asgari yarım gün tabanı vardır).
  /// 3. Eğer kiralama 7 gün veya üzeriyse %15 indirim uygular.
  /// 4. Dart 3 Record ile hesaplama sonucunu tip güvenli olarak döndürür.
  static ({
    double basePrice,
    double discountAmount,
    double totalPrice,
    int days,
    int hours,
    bool isDiscountApplied,
  }) calculateRentalPrice({
    required double dailyPrice,
    required double hourlyPrice,
    required DateTime start,
    required DateTime end,
  }) {
    // 1. Süre analizi (Kaç gün, kaç saat?)
    final duration = AppDateUtils.calculateDuration(start, end);
    final days = duration.days;
    final hours = duration.hours;

    double rawPrice = 0.0;

    // 2. Gün ve saat durumuna göre ham fiyat hesaplama
    if (days == 0 && hours == 0) {
      // Başlangıç ve bitiş aynı seçilmişse asgari 1 günlük kiralama ücreti yansıtılır
      rawPrice = dailyPrice;
    } else if (days == 0) {
      // 24 saatten az kiralamalar:
      // Saatlik ücret toplamı günlük ücreti aşamaz (tavan kuralı).
      final hourlyTotal = hours * hourlyPrice;
      rawPrice = hourlyTotal > dailyPrice ? dailyPrice : hourlyTotal;

      // Sistem asgari yarım gün ücreti tabanını (base floor) korur
      if (rawPrice < dailyPrice * 0.5) {
        rawPrice = dailyPrice * 0.5;
      }
    } else {
      // 1 gün veya daha uzun süreli kiralamalar:
      final extraHoursPrice = hours * hourlyPrice;
      // Kalan ekstra saatlerin ücreti 1 tam günü geçiyorsa tavan olarak 1 gün ücreti eklenir
      final cappedExtra = extraHoursPrice > dailyPrice ? dailyPrice : extraHoursPrice;
      rawPrice = (days * dailyPrice) + cappedExtra;
    }

    // 3. Uzun Dönem İndirimi (%15 Kuralı):
    // Kiralama süresi en az 7 gün ise AppConstants.longTermDiscountRate (%15) uygulanır.
    final bool isDiscountApplied = days >= AppConstants.longTermDiscountDays;
    double discountAmount = 0.0;

    if (isDiscountApplied) {
      discountAmount = rawPrice * AppConstants.longTermDiscountRate;
    }

    // Nihai ödenecek tutar
    final totalPrice = rawPrice - discountAmount;

    // 4. Sonucu Record olarak döndür
    return (
      basePrice: rawPrice,
      discountAmount: discountAmount,
      totalPrice: totalPrice,
      days: days == 0 && hours > 0 ? 1 : days,
      hours: hours,
      isDiscountApplied: isDiscountApplied,
    );
  }
}

