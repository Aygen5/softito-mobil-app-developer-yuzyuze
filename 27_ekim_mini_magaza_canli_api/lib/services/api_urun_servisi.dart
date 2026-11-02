import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/urun.dart';
import 'i_urun_servisi.dart';

// ApiUrunServisi:
// IUrunServisi sözleşmesini uygulayan ve FakeStore REST API'ye gerçek internet istekleri atan somut sınıfımızdır.
class ApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = 'https://fakestoreapi.com';
  // Ağ isteklerinin sonsuz döngüde asılı kalmaması için 10 saniyelik zaman aşımı süresi belirledik
  static const Duration _zamanAsimi = Duration(seconds: 10);

  @override
  Future<List<Urun>> urunleriGetir() async {
    try {
      final uri = Uri.parse('$_baseUrl/products');
      // http.get ile sunucuya istek gönderiyoruz ve zaman aşımı koruması uyguluyoruz
      final yanit = await http.get(uri).timeout(_zamanAsimi);

      // 200 OK: İstek başarılı
      if (yanit.statusCode == 200) {
        // Türkçe ve özel karakterlerin bozulmasını önlemek için body yerine bodyBytes üzerinden UTF-8 çözümlüyoruz
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        final List<dynamic> jsonListesi = jsonDecode(cozulmusGovde) as List<dynamic>;

        // Gelen JSON haritalarını Urun.fromJson ile Urun nesnelerine dönüştürüp liste yapıyoruz
        return jsonListesi
            .map((oge) => Urun.fromJson(oge as Map<String, dynamic>))
            .toList();
      } else {
        // Sunucu 404, 500 gibi bir hata kodu dönerse istisna fırlatıyoruz
        throw Exception('Sunucu hatası: HTTP ${yanit.statusCode}');
      }
    } catch (hata) {
      // Hatayı UI (ekran) katmanı yakalayıp ekranda kırmızı mesaj basabilsin diye tekrar fırlatıyoruz (rethrow)
      rethrow;
    }
  }

  @override
  Future<Urun?> urunGetirById(int id) async {
    try {
      final uri = Uri.parse('$_baseUrl/products/$id');
      final yanit = await http.get(uri).timeout(_zamanAsimi);

      if (yanit.statusCode == 200) {
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);
        final Map<String, dynamic> jsonHaritasi = jsonDecode(cozulmusGovde) as Map<String, dynamic>;
        return Urun.fromJson(jsonHaritasi);
      } else {
        return null; // Ürün bulunamazsa null dönüyoruz
      }
    } catch (hata) {
      return null;
    }
  }
}

