import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. MODEL SINIFI:
// REST API'den dönecek ürün verilerini temsil eden tip güvenli sınıf.
class UrunModel {
  final int id;
  final String baslik;
  final double fiyat;
  final String resimUrl;
  final String kategori;

  const UrunModel({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
  });

  // fromJson fabrika kurucusu:
  // Sunucudan gelen Map<String, dynamic> formatındaki JSON verisini UrunModel nesnesine dönüştürür.
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // API'den fiyat tam sayı da gelse ondalıklı da gelse toDouble() ile güvenle double yapıyoruz
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      // category veya kategori anahtarından hangisi doluysa onu alır
      kategori: (json['category'] ?? json['kategori']) as String? ?? 'Genel',
    );
  }
}

// 2. SERVİS SÖZLEŞMESİ (Interface):
// Katmanlı mimaride arayüz (UI) doğrudan API koduna değil, bu soyut sınıfa güvenir.
// Böylece servis değişse bile arayüz kodunu bozmadan geçiş yapabiliriz.
abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

// 3. CANLI API SERVİSİ:
// Gerçek internet bağlantısı kurup FakeStoreAPI'den ürünleri çeken somut sınıf.
class CanliApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      // http.get ile isteği atıyoruz, 10 saniye içinde yanıt gelmezse timeout fırlatıyoruz
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Ağ zaman aşımına uğradı.');
        },
      );

      // 200 Başarılı yanıt
      if (yanit.statusCode == 200) {
        // Gelen metin cevabı JSON listesine ayrıştırıyoruz
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        // Her elemanı UrunModel'e çevirip List<UrunModel> olarak döndürüyoruz
        return hamListe
            .map((json) => UrunModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu hatası: ${yanit.statusCode}');
      }
    } catch (e) {
      throw Exception('Ağ hatası: $e');
    }
  }
}
