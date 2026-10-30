import 'kategori.dart';
import 'degerlendirme.dart';

class Urun {
    final int id;
    final String baslik;
    final String aciklama;
    final double fiyat;
    final String resimUrl;
    final Kategori kategori;
    final int stokAdedi;
    final bool favoriMi;
    final Degerlendirme degerlendirme;

    const Urun({
        required this.id,
        required this.baslik,
        required this.aciklama,
        required this.fiyat,
        required this.resimUrl,
        required this.kategori,
        required this.stokAdedi,
        this.favoriMi = false, //tek bu alanı değiştiriyoruz copyWith için bir tanede aynısından favori olanı alıcaz
        required this.degerlendirme,
    }); 

    static Kategori _kategoriCozumle(dynamic kategoriJson) {
        if (kategoriJson == null) return Kategori.hepsi;
        final katStr = kategoriJson.toString().toLowerCase().trim();
        if (katStr.contains('electr')) {
            return Kategori.elektronik;
        } else if (katStr.contains('cloth') || katStr.contains('giyim')) {
            return Kategori.giyim;
        } else if (katStr.contains('jewel') || katStr.contains('aksesuar')) {
            return Kategori.aksesuar;
        } else if (katStr.contains('shoe') || katStr.contains('ayak')) {
            return Kategori.ayakkabi;
        }
        return Kategori.hepsi;
    }

    factory Urun.fromJson(Map<String,dynamic> json){
        return Urun(
            id: (json['id'] as num?)?.toInt() ?? 0,
            baslik: json['title'] as String? ?? '',
            fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
            aciklama: json['description'] as String? ?? '',
            kategori: _kategoriCozumle(json['category']),
            stokAdedi: (json['stokAdedi'] as num?)?.toInt() ?? 
                ((json['rating'] is Map && json['rating']['count'] != null) 
                    ? (json['rating']['count'] as num).toInt() 
                    : 10),
            resimUrl: json['image'] as String? ?? '', 
            degerlendirme: Degerlendirme.fromJson(json['rating'] is Map<String, dynamic> ? json['rating'] as Map<String, dynamic> : null),
            favoriMi: false,
        );
    }

    Urun copyWith({
        int? id,
        String? baslik,
        String? aciklama,
        double? fiyat,
        String? resimUrl,
        Kategori? kategori,
        int? stokAdedi,
        bool? favoriMi,
        Degerlendirme? degerlendirme,
    }){
        return Urun(
            id: id?? this.id,
            baslik: baslik?? this.baslik,
            aciklama: aciklama?? this.aciklama,
            fiyat: fiyat?? this.fiyat,
            resimUrl: resimUrl?? this.resimUrl,
            kategori: kategori?? this.kategori,
            stokAdedi: stokAdedi?? this.stokAdedi,
            favoriMi: favoriMi?? this.favoriMi,
            degerlendirme: degerlendirme ?? this.degerlendirme,
        );
    }

    @override
    String toString(){
        return "Urun(id: $id,baslik: $baslik,fiyat: $fiyat ₺,favoriMi: $favoriMi)";
    }
}