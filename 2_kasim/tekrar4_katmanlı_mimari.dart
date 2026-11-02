import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. MODEL KATMANI:
// API'den gelen karmaşık JSON verisini tip güvenli bir Dart nesnesine dönüştürmek için yazdığımız sınıf.
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
  // Sunucudan gelen Map<String, dynamic> verisini okuyup UrunModel nesnesi üretir.
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      // null gelme ihtimaline karşı varsayılan değerler (??) atadık
      id: json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // Fiyat API'den 109 veya 109.95 gelebilir. Tip uyuşmazlığı olmasın diye num? -> toDouble() kullandık.
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      kategori: json['kategori'] as String? ?? 'Genel',
    );
  }
}

// 2. SERVİS ARAYÜZÜ (Interface):
// Katmanlı mimarinin temeli. Ekran doğrudan somut sınıfa değil, bu arayüze bağımlı olur.
// Böylece yarın bir gün test için sahte (mock) veri veya başka bir API'ye geçmek çok kolaylaşır.
abstract class IUrunServisi{
  Future<List<UrunModel>> urunleriGetir();
}

// 3. SOMUT SERVİS KATMANI:
// IUrunServisi sözleşmesini uygulayarak internet üzerinden gerçek API isteği yapan sınıf.
class CanliApiUrunServisi implements IUrunServisi {
  // Veriyi çekeceğimiz temel uç nokta
  static const String _base_url = 'https://fakestoreapi.com/products';

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try{
      // http.get ile sunucuya istek gönderiyoruz.
      // timeout: İnternet kesilirse sonsuza kadar beklemesin, 10 sn sonra hata versin diye eklendi.
      final yanit = await http.get(Uri.parse(_base_url)).timeout(
        const Duration(seconds: 10),
        onTimeout:(){
          throw Exception('Ağ zaman aşımına uğradı.');
        },
      );

      // 200 OK: İstek başarılı, veriler elimizde
      if(yanit.statusCode==200){
        // jsonDecode: Gelen metin (string) halindeki JSON'ı Dart List yapısına çevirir
        final List<dynamic> hamListe=jsonDecode(yanit.body) as List <dynamic>;
        // Listedeki her elemanı UrunModel.fromJson ile nesneye çevirip liste olarak dönüyoruz
        return hamListe.map((json) => UrunModel.fromJson(json as Map<String,dynamic>)).toList();
      }
      else{
        // 404, 500 gibi sunucu kaynaklı hatalar
        throw Exception('Sunucu hatası: ${yanit.statusCode}');
      }
      }
      catch(e){
        // Bağlantı kopması veya format hatası durumunda hatayı yukarıya fırlatıyoruz
        throw Exception('Ağ hatası: $e');
      }
  }
}