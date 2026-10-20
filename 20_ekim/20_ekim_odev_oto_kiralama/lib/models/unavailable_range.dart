/// ---------------------------------------------------------------------------
/// 🔒 UnavailableRange — Dolu Tarih Aralığı Veri Modeli
/// ---------------------------------------------------------------------------
/// Bir aracın önceden kiralanmış veya bakımda olduğu için kiralanamayacak
/// olan başlangıç ve bitiş tarih aralığını temsil eder.
/// 'vehicles.json' dosyasındaki "unavailableRanges" dizisinden okunur.
class UnavailableRange {
  /// Rezervasyonun başladığı an (örn: 2026-10-22 10:00:00)
  final DateTime startDate;

  /// Rezervasyonun bittiği an (örn: 2026-10-25 10:00:00)
  final DateTime endDate;

  /// 'const' yapıcı: Nesnenin özellikleri 'final' (değiştirilemez) olduğu için
  /// derleme aşamasında sabit olarak oluşturulabilir.
  const UnavailableRange({
    required this.startDate,
    required this.endDate,
  });

  /// 'factory constructor' (Fabrika Kurucu):
  /// Dart'ta normal yapıcılar her zaman o sınıfın yeni bir örneğini oluştururken,
  /// factory yapıcılar hesaplama yapabilir, veriyi ayrıştırabilir (parse)
  /// ve uygun nesneyi döndürür.
  /// JSON haritasından (`Map<String, dynamic>`) bir UnavailableRange nesnesi üretir.
  factory UnavailableRange.fromJson(Map<String, dynamic> json) {
    return UnavailableRange(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  /// Nesneyi JSON haritasına dönüştürür (Serileştirme - Serialization).
  /// 'toIso8601String()': Tarihi '2026-10-22T10:00:00.000Z' standart metnine çevirir.
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  /// 'operator ==' ve 'hashCode' (Değer Eşitliği - Value Equality):
  /// Dart'ta varsayılan olarak iki nesne yalnızca bellekteki adresleri (referansları)
  /// aynı ise eşit (`==`) kabul edilir.
  /// Ancak veri modellerinde, içlerindeki veriler (startDate ve endDate) aynıysa
  /// bu iki nesneyi eşit saymak isteriz.
  /// Bu yüzden 'operator ==' ve 'hashCode' ezilir (override edilir).
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UnavailableRange &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}

