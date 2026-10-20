import 'package:flutter/foundation.dart';

enum EslesmeDurumu { yok, beklemede, eslesti }

@immutable
class MentorModel {
  final String id;
  final String ad;
  final String unvan;
  final String sirket;
  final String sektor;
  final List<String> uzmanliklar;
  final int deneyimYili;
  final double puan;
  final String aciklama;
  final bool musaitMi;
  final EslesmeDurumu durum;

  const MentorModel({
    required this.id,
    required this.ad,
    required this.unvan,
    required this.sirket,
    required this.sektor,
    required this.uzmanliklar,
    required this.deneyimYili,
    required this.puan,
    required this.aciklama,
    this.musaitMi = true,
    this.durum = EslesmeDurumu.yok,
  });

  MentorModel copyWith({
    String? id,
    String? ad,
    String? unvan,
    String? sirket,
    String? sektor,
    List<String>? uzmanliklar,
    int? deneyimYili,
    double? puan,
    String? aciklama,
    bool? musaitMi,
    EslesmeDurumu? durum,
  }) {
    return MentorModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      unvan: unvan ?? this.unvan,
      sirket: sirket ?? this.sirket,
      sektor: sektor ?? this.sektor,
      uzmanliklar: uzmanliklar ?? this.uzmanliklar,
      deneyimYili: deneyimYili ?? this.deneyimYili,
      puan: puan ?? this.puan,
      aciklama: aciklama ?? this.aciklama,
      musaitMi: musaitMi ?? this.musaitMi,
      durum: durum ?? this.durum,
    );
  }

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] as String? ?? '',
      ad: json['ad'] as String? ?? '',
      unvan: json['unvan'] as String? ?? '',
      sirket: json['sirket'] as String? ?? '',
      sektor: json['sektor'] as String? ?? '',
      uzmanliklar: (json['uzmanliklar'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deneyimYili: (json['deneyimYili'] as num?)?.toInt() ?? 0,
      puan: (json['puan'] as num?)?.toDouble() ?? 5.0,
      aciklama: json['aciklama'] as String? ?? '',
      musaitMi: json['musaitMi'] as bool? ?? true,
      durum: EslesmeDurumu.values.firstWhere(
        (e) => e.name == json['durum'],
        orElse: () => EslesmeDurumu.yok,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'unvan': unvan,
      'sirket': sirket,
      'sektor': sektor,
      'uzmanliklar': uzmanliklar,
      'deneyimYili': deneyimYili,
      'puan': puan,
      'aciklama': aciklama,
      'musaitMi': musaitMi,
      'durum': durum.name,
    };
  }
}
