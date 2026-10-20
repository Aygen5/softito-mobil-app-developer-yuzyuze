import 'package:flutter/foundation.dart';

enum ToplulukKullaniciDurumu { onaysiz, incelemede, onayli }

@immutable
class ToplulukYanitModel {
  final String id;
  final String yazar;
  final String unvan;
  final String metin;
  final DateTime tarih;

  const ToplulukYanitModel({
    required this.id,
    required this.yazar,
    required this.unvan,
    required this.metin,
    required this.tarih,
  });

  ToplulukYanitModel copyWith({
    String? id,
    String? yazar,
    String? unvan,
    String? metin,
    DateTime? tarih,
  }) {
    return ToplulukYanitModel(
      id: id ?? this.id,
      yazar: yazar ?? this.yazar,
      unvan: unvan ?? this.unvan,
      metin: metin ?? this.metin,
      tarih: tarih ?? this.tarih,
    );
  }

  factory ToplulukYanitModel.fromJson(Map<String, dynamic> json) {
    return ToplulukYanitModel(
      id: json['id'] as String? ?? '',
      yazar: json['yazar'] as String? ?? '',
      unvan: json['unvan'] as String? ?? '',
      metin: json['metin'] as String? ?? '',
      tarih: json['tarih'] != null
          ? DateTime.tryParse(json['tarih'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yazar': yazar,
      'unvan': unvan,
      'metin': metin,
      'tarih': tarih.toIso8601String(),
    };
  }
}

@immutable
class ToplulukGonderiModel {
  final String id;
  final String yazar;
  final String girisimAdi;
  final String metin;
  final DateTime tarih;
  final int begeniSayisi;
  final bool begenildi;
  final List<ToplulukYanitModel> yanitlar;

  const ToplulukGonderiModel({
    required this.id,
    required this.yazar,
    required this.girisimAdi,
    required this.metin,
    required this.tarih,
    this.begeniSayisi = 0,
    this.begenildi = false,
    this.yanitlar = const [],
  });

  ToplulukGonderiModel copyWith({
    String? id,
    String? yazar,
    String? girisimAdi,
    String? metin,
    DateTime? tarih,
    int? begeniSayisi,
    bool? begenildi,
    List<ToplulukYanitModel>? yanitlar,
  }) {
    return ToplulukGonderiModel(
      id: id ?? this.id,
      yazar: yazar ?? this.yazar,
      girisimAdi: girisimAdi ?? this.girisimAdi,
      metin: metin ?? this.metin,
      tarih: tarih ?? this.tarih,
      begeniSayisi: begeniSayisi ?? this.begeniSayisi,
      begenildi: begenildi ?? this.begenildi,
      yanitlar: yanitlar ?? this.yanitlar,
    );
  }

  factory ToplulukGonderiModel.fromJson(Map<String, dynamic> json) {
    return ToplulukGonderiModel(
      id: json['id'] as String? ?? '',
      yazar: json['yazar'] as String? ?? '',
      girisimAdi: json['girisimAdi'] as String? ?? '',
      metin: json['metin'] as String? ?? '',
      tarih: json['tarih'] != null
          ? DateTime.tryParse(json['tarih'] as String) ?? DateTime.now()
          : DateTime.now(),
      begeniSayisi: (json['begeniSayisi'] as num?)?.toInt() ?? 0,
      begenildi: json['begenildi'] as bool? ?? false,
      yanitlar: (json['yanitlar'] as List<dynamic>?)
              ?.map(
                (e) => ToplulukYanitModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yazar': yazar,
      'girisimAdi': girisimAdi,
      'metin': metin,
      'tarih': tarih.toIso8601String(),
      'begeniSayisi': begeniSayisi,
      'begenildi': begenildi,
      'yanitlar': yanitlar.map((e) => e.toJson()).toList(),
    };
  }
}
