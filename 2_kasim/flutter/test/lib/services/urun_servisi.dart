import 'dart:convert';
import 'package:http/http.dart' as http;

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

  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      kategori: (json['category'] ?? json['kategori']) as String? ?? 'Genel',
    );
  }
}

abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Ağ zaman aşımına uğradı.');
        },
      );

      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
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
