import 'package:flutter/foundation.dart';

enum YatirimciKategori {
  sirketler('Şirketler'),
  holdingler('Holdingler'),
  melekYatirimcilar('Melek Yatırımcılar'),
  girisimSermayesi('Girişim Sermayesi (VC)');

  final String baslik;
  const YatirimciKategori(this.baslik);
}

@immutable
class YatirimciModel {
  final String id;
  final String ad;
  final YatirimciKategori kategori;
  final String asama; // Örn: Tohum Öncesi, Tohum, Seri A, Seri B
  final List<String> sektorler;
  final String biletAraligi; // Örn: 50.000$ - 250.000$
  final List<String> portfoy;
  final String eposta;
  final String telefon;
  final String web;
  final String aciklama;
  final bool iletisimTalebiGonderildi;

  const YatirimciModel({
    required this.id,
    required this.ad,
    required this.kategori,
    required this.asama,
    required this.sektorler,
    required this.biletAraligi,
    required this.portfoy,
    required this.eposta,
    required this.telefon,
    required this.web,
    required this.aciklama,
    this.iletisimTalebiGonderildi = false,
  });

  YatirimciModel copyWith({
    String? id,
    String? ad,
    YatirimciKategori? kategori,
    String? asama,
    List<String>? sektorler,
    String? biletAraligi,
    List<String>? portfoy,
    String? eposta,
    String? telefon,
    String? web,
    String? aciklama,
    bool? iletisimTalebiGonderildi,
  }) {
    return YatirimciModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      kategori: kategori ?? this.kategori,
      asama: asama ?? this.asama,
      sektorler: sektorler ?? this.sektorler,
      biletAraligi: biletAraligi ?? this.biletAraligi,
      portfoy: portfoy ?? this.portfoy,
      eposta: eposta ?? this.eposta,
      telefon: telefon ?? this.telefon,
      web: web ?? this.web,
      aciklama: aciklama ?? this.aciklama,
      iletisimTalebiGonderildi:
          iletisimTalebiGonderildi ?? this.iletisimTalebiGonderildi,
    );
  }

  factory YatirimciModel.fromJson(Map<String, dynamic> json) {
    return YatirimciModel(
      id: json['id'] as String? ?? '',
      ad: json['ad'] as String? ?? '',
      kategori: YatirimciKategori.values.firstWhere(
        (e) => e.name == json['kategori'],
        orElse: () => YatirimciKategori.sirketler,
      ),
      asama: json['asama'] as String? ?? '',
      sektorler: (json['sektorler'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      biletAraligi: json['biletAraligi'] as String? ?? '',
      portfoy: (json['portfoy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      eposta: json['eposta'] as String? ?? '',
      telefon: json['telefon'] as String? ?? '',
      web: json['web'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      iletisimTalebiGonderildi:
          json['iletisimTalebiGonderildi'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'kategori': kategori.name,
      'asama': asama,
      'sektorler': sektorler,
      'biletAraligi': biletAraligi,
      'portfoy': portfoy,
      'eposta': eposta,
      'telefon': telefon,
      'web': web,
      'aciklama': aciklama,
      'iletisimTalebiGonderildi': iletisimTalebiGonderildi,
    };
  }
}
