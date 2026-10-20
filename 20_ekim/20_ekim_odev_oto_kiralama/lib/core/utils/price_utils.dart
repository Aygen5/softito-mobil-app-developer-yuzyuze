import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import 'date_utils.dart';

class AppPriceUtils {
  AppPriceUtils._();

  static final NumberFormat _currencyFormat = NumberFormat('#,##0', 'tr_TR');

  // Para birimi formatla: 1.450 ₺
  static String formatPrice(num price) {
    return '${_currencyFormat.format(price)} ${AppConstants.currencySymbol}';
  }

  // Günlük fiyat formatla: 1.450 ₺ / gün
  static String formatDailyPrice(num dailyPrice) {
    return '${formatPrice(dailyPrice)} / gün';
  }

  // Saatlik fiyat formatla: 120 ₺ / saat
  static String formatHourlyPrice(num hourlyPrice) {
    return '${formatPrice(hourlyPrice)} / saat';
  }

  // Rezervasyon toplam ücretini hesapla
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
    final duration = AppDateUtils.calculateDuration(start, end);
    final days = duration.days;
    final hours = duration.hours;

    // Minimum kiralama süresi 1 gün olarak kabul edilir (veya en az 24 saat)
    double rawPrice = 0.0;

    if (days == 0 && hours == 0) {
      rawPrice = dailyPrice;
    } else if (days == 0) {
      // 24 saatten az ise: saatlik ücret hesabı yapılır fakat günlük ücreti geçemez
      final hourlyTotal = hours * hourlyPrice;
      rawPrice = hourlyTotal > dailyPrice ? dailyPrice : hourlyTotal;
      if (rawPrice < dailyPrice * 0.5) {
        // Asgari yarım gün ücreti tabanı
        rawPrice = dailyPrice * 0.5;
      }
    } else {
      // Günlük kiralama + kalan saatler
      final extraHoursPrice = hours * hourlyPrice;
      // Ekstra saatler 1 günün günlük ücretini aşarsa en fazla 1 gün eklenir
      final cappedExtra = extraHoursPrice > dailyPrice ? dailyPrice : extraHoursPrice;
      rawPrice = (days * dailyPrice) + cappedExtra;
    }

    // 7 gün ve üzeri kiralamalarda uzun dönem indirimi (%15)
    final bool isDiscountApplied = days >= AppConstants.longTermDiscountDays;
    double discountAmount = 0.0;

    if (isDiscountApplied) {
      discountAmount = rawPrice * AppConstants.longTermDiscountRate;
    }

    final totalPrice = rawPrice - discountAmount;

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
