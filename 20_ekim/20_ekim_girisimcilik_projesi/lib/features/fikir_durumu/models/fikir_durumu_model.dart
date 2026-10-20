import 'package:flutter/foundation.dart';

enum BasvuruAsamasi {
  gonderildi('Başvuru Gönderildi'),
  inceleniyor('Uzman İncelemesinde'),
  revizeIstendi('Revize İstendi'),
  onaylandi('Kabul Edildi & Yörüngede');

  final String baslik;
  const BasvuruAsamasi(this.baslik);
}

enum HukukiAdimDurumu { tamamlandi, devamEdiyor, sirada }

@immutable
class HukukiSurecAdimi {
  final int sira;
  final String baslik;
  final String aciklama;
  final HukukiAdimDurumu durum;

  const HukukiSurecAdimi({
    required this.sira,
    required this.baslik,
    required this.aciklama,
    required this.durum,
  });

  HukukiSurecAdimi copyWith({
    int? sira,
    String? baslik,
    String? aciklama,
    HukukiAdimDurumu? durum,
  }) {
    return HukukiSurecAdimi(
      sira: sira ?? this.sira,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      durum: durum ?? this.durum,
    );
  }

  factory HukukiSurecAdimi.fromJson(Map<String, dynamic> json) {
    return HukukiSurecAdimi(
      sira: (json['sira'] as num?)?.toInt() ?? 1,
      baslik: json['baslik'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      durum: HukukiAdimDurumu.values.firstWhere(
        (e) => e.name == json['durum'],
        orElse: () => HukukiAdimDurumu.sirada,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sira': sira,
      'baslik': baslik,
      'aciklama': aciklama,
      'durum': durum.name,
    };
  }
}

@immutable
class AtananAvukatModel {
  final String adSoyad;
  final String baroSicilNo;
  final String uzmanlik;
  final String eposta;
  final String telefon;

  const AtananAvukatModel({
    required this.adSoyad,
    required this.baroSicilNo,
    required this.uzmanlik,
    required this.eposta,
    required this.telefon,
  });

  factory AtananAvukatModel.fromJson(Map<String, dynamic> json) {
    return AtananAvukatModel(
      adSoyad: json['adSoyad'] as String? ?? '',
      baroSicilNo: json['baroSicilNo'] as String? ?? '',
      uzmanlik: json['uzmanlik'] as String? ?? '',
      eposta: json['eposta'] as String? ?? '',
      telefon: json['telefon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adSoyad': adSoyad,
      'baroSicilNo': baroSicilNo,
      'uzmanlik': uzmanlik,
      'eposta': eposta,
      'telefon': telefon,
    };
  }
}

@immutable
class GelirDestekModel {
  final double aylikHedefTl;
  final double gerceklesenTl;
  final String taahhutBitisTarihi;
  final String aciklama;

  const GelirDestekModel({
    required this.aylikHedefTl,
    required this.gerceklesenTl,
    required this.taahhutBitisTarihi,
    required this.aciklama,
  });

  double get ilerlemeOrani =>
      aylikHedefTl > 0 ? (gerceklesenTl / aylikHedefTl).clamp(0.0, 1.0) : 0.0;

  factory GelirDestekModel.fromJson(Map<String, dynamic> json) {
    return GelirDestekModel(
      aylikHedefTl: (json['aylikHedefTl'] as num?)?.toDouble() ?? 0.0,
      gerceklesenTl: (json['gerceklesenTl'] as num?)?.toDouble() ?? 0.0,
      taahhutBitisTarihi: json['taahhutBitisTarihi'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aylikHedefTl': aylikHedefTl,
      'gerceklesenTl': gerceklesenTl,
      'taahhutBitisTarihi': taahhutBitisTarihi,
      'aciklama': aciklama,
    };
  }
}

@immutable
class FikirDurumuModel {
  final String id;
  final String fikirAdi;
  final String sektor;
  final String aciklama;
  final BasvuruAsamasi basvuruAsamasi;
  final List<HukukiSurecAdimi> hukukiAdimlar;
  final AtananAvukatModel avukat;
  final GelirDestekModel gelirDestegi;

  const FikirDurumuModel({
    required this.id,
    required this.fikirAdi,
    required this.sektor,
    required this.aciklama,
    required this.basvuruAsamasi,
    required this.hukukiAdimlar,
    required this.avukat,
    required this.gelirDestegi,
  });

  FikirDurumuModel copyWith({
    String? id,
    String? fikirAdi,
    String? sektor,
    String? aciklama,
    BasvuruAsamasi? basvuruAsamasi,
    List<HukukiSurecAdimi>? hukukiAdimlar,
    AtananAvukatModel? avukat,
    GelirDestekModel? gelirDestegi,
  }) {
    return FikirDurumuModel(
      id: id ?? this.id,
      fikirAdi: fikirAdi ?? this.fikirAdi,
      sektor: sektor ?? this.sektor,
      aciklama: aciklama ?? this.aciklama,
      basvuruAsamasi: basvuruAsamasi ?? this.basvuruAsamasi,
      hukukiAdimlar: hukukiAdimlar ?? this.hukukiAdimlar,
      avukat: avukat ?? this.avukat,
      gelirDestegi: gelirDestegi ?? this.gelirDestegi,
    );
  }

  factory FikirDurumuModel.fromJson(Map<String, dynamic> json) {
    return FikirDurumuModel(
      id: json['id'] as String? ?? '',
      fikirAdi: json['fikirAdi'] as String? ?? '',
      sektor: json['sektor'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      basvuruAsamasi: BasvuruAsamasi.values.firstWhere(
        (e) => e.name == json['basvuruAsamasi'],
        orElse: () => BasvuruAsamasi.onaylandi,
      ),
      hukukiAdimlar: (json['hukukiAdimlar'] as List<dynamic>?)
              ?.map((e) => HukukiSurecAdimi.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      avukat: AtananAvukatModel.fromJson(
        json['avukat'] as Map<String, dynamic>? ?? {},
      ),
      gelirDestegi: GelirDestekModel.fromJson(
        json['gelirDestegi'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fikirAdi': fikirAdi,
      'sektor': sektor,
      'aciklama': aciklama,
      'basvuruAsamasi': basvuruAsamasi.name,
      'hukukiAdimlar': hukukiAdimlar.map((e) => e.toJson()).toList(),
      'avukat': avukat.toJson(),
      'gelirDestegi': gelirDestegi.toJson(),
    };
  }
}
