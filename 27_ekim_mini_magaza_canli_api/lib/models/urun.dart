import 'kategori.dart';
import 'degerlendirme.dart';

// Urun Modeli:
// API'den gelen ürün verilerini uygulamamızda güvenle kullanmak için tanımladığımız model.
// Değişmez (immutable) tutabilmek için tüm alanları final yaptık.
class Urun {
  final int id;                       // Ürünün benzersiz kimlik numarası
  final String baslik;                // Ürün adı (title)
  final double fiyat;                 // Ürün fiyatı (price)
  final String aciklama;              // Ürün açıklaması (description)
  final Kategori kategori;            // String yerine tip güvenli enum yaptık
  final String resimUrl;              // Ürün görselinin internet bağlantısı (image)
  final Degerlendirme degerlendirme;   // İç içe model: Oy ve puan bilgisi (rating)
  final bool stoktaVarMi;             // Stok kontrolü

  const Urun({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.aciklama,
    required this.kategori,
    required this.resimUrl,
    required this.degerlendirme,
    this.stoktaVarMi = true,
  });

  // fromJson: FakeStore API'den gelen ham JSON haritasını (Map<String, dynamic>)
  // tip güvenli bir Urun nesnesine dönüştürmek için kullandık.
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: (json['id'] as num).toInt(),
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // Fiyat bazen int (100) bazen double (100.5) gelebilir, çökmemesi için num? -> toDouble() yaptık
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      aciklama: json['description'] as String? ?? '',
      // String gelen kategoriyi enum'a dönüştürdük
      kategori: KategoriExtension.apiMetnindenUret(json['category'] as String? ?? ''),
      resimUrl: json['image'] as String? ?? '',
      // rating alanı varsa alt modele çözümlüyoruz, yoksa varsayılan boş nesne koyuyoruz
      degerlendirme: json['rating'] != null
          ? Degerlendirme.fromJson(json['rating'] as Map<String, dynamic>)
          : const Degerlendirme(puan: 0.0, oySayisi: 0),
      // FakeStore API'de stok alanı olmadığı için oy sayısı (count) 0 olanları temsili stok dışı saydık
      stoktaVarMi: ((json['rating']?['count'] as num?)?.toInt() ?? 10) > 0,
    );
  }

  // copyWith: Bir ürünün mevcut verilerini koruyarak sadece belli alanlarını
  // (örneğin sepet durumu veya stok bilgisi) değiştirmek amacıyla kullandığımız metottur.
  Urun copyWith({
    int? id,
    String? baslik,
    double? fiyat,
    String? aciklama,
    Kategori? kategori,
    String? resimUrl,
    Degerlendirme? degerlendirme,
    bool? stoktaVarMi,
  }) {
    return Urun(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      fiyat: fiyat ?? this.fiyat,
      aciklama: aciklama ?? this.aciklama,
      kategori: kategori ?? this.kategori,
      resimUrl: resimUrl ?? this.resimUrl,
      degerlendirme: degerlendirme ?? this.degerlendirme,
      stoktaVarMi: stoktaVarMi ?? this.stoktaVarMi,
    );
  }
}

