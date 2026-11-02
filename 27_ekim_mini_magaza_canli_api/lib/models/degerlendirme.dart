// Degerlendirme Modeli:
// FakeStore API'deki her ürünün içinde gelen "rating": {"rate": 3.9, "count": 120}
// yapısını karşılayan iç içe (nested) model sınıfıdır.
class Degerlendirme {
  final double puan;    // Ürünün ortalama puanı (rate)
  final int oySayisi;   // Ürüne verilen toplam oy adedi (count)

  const Degerlendirme({
    required this.puan,
    required this.oySayisi,
  });

  // fromJson: JSON haritasındaki verileri Degerlendirme nesnesine çevirir.
  // num? -> toDouble() ve toInt() kullandık; çünkü API bazen 4 bazen 4.0 yollayabiliyor, tür hatası almamak için.
  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    return Degerlendirme(
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  // toJson: Modeli tekrar API'ye göndermek istersek JSON Map yapısına geri çevirir.
  Map<String, dynamic> toJson() {
    return {
      'rate': puan,
      'count': oySayisi,
    };
  }
}

