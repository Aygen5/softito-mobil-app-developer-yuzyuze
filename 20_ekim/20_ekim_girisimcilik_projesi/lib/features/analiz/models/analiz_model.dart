import 'package:flutter/foundation.dart';

@immutable
class EkipUyesiModel {
  final String id;
  final String adSoyad;
  final String egitim;
  final String uzmanlik;
  final String sorumluluk;
  final String iletisim;

  const EkipUyesiModel({
    required this.id,
    required this.adSoyad,
    required this.egitim,
    required this.uzmanlik,
    required this.sorumluluk,
    required this.iletisim,
  });

  EkipUyesiModel copyWith({
    String? id,
    String? adSoyad,
    String? egitim,
    String? uzmanlik,
    String? sorumluluk,
    String? iletisim,
  }) {
    return EkipUyesiModel(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      egitim: egitim ?? this.egitim,
      uzmanlik: uzmanlik ?? this.uzmanlik,
      sorumluluk: sorumluluk ?? this.sorumluluk,
      iletisim: iletisim ?? this.iletisim,
    );
  }

  factory EkipUyesiModel.fromJson(Map<String, dynamic> json) {
    return EkipUyesiModel(
      id: json['id'] as String? ?? '',
      adSoyad: json['adSoyad'] as String? ?? '',
      egitim: json['egitim'] as String? ?? '',
      uzmanlik: json['uzmanlik'] as String? ?? '',
      sorumluluk: json['sorumluluk'] as String? ?? '',
      iletisim: json['iletisim'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adSoyad': adSoyad,
      'egitim': egitim,
      'uzmanlik': uzmanlik,
      'sorumluluk': sorumluluk,
      'iletisim': iletisim,
    };
  }
}

@immutable
class GanttGorevModel {
  final String id;
  final String gorevAdi;
  final String baslangicAy;
  final String bitisAy;

  const GanttGorevModel({
    required this.id,
    required this.gorevAdi,
    required this.baslangicAy,
    required this.bitisAy,
  });

  GanttGorevModel copyWith({
    String? id,
    String? gorevAdi,
    String? baslangicAy,
    String? bitisAy,
  }) {
    return GanttGorevModel(
      id: id ?? this.id,
      gorevAdi: gorevAdi ?? this.gorevAdi,
      baslangicAy: baslangicAy ?? this.baslangicAy,
      bitisAy: bitisAy ?? this.bitisAy,
    );
  }

  factory GanttGorevModel.fromJson(Map<String, dynamic> json) {
    return GanttGorevModel(
      id: json['id'] as String? ?? '',
      gorevAdi: json['gorevAdi'] as String? ?? '',
      baslangicAy: json['baslangicAy'] as String? ?? '',
      bitisAy: json['bitisAy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gorevAdi': gorevAdi,
      'baslangicAy': baslangicAy,
      'bitisAy': bitisAy,
    };
  }
}

@immutable
class AnalizFormModel {
  // 1. Fikir Özeti
  final String fikirAdi;
  final String sektor;
  final String problem;
  final String cozum;
  final String hedefKitle;

  // 2. Ekip
  final List<EkipUyesiModel> ekipUyeleri;

  // 3. Traction
  final bool musteriVarMi;
  final String musteriDetay;
  final double hedefeYakinlikYuzdesi;
  final String ciro;
  final String karDurumu;

  // 4. İnovasyon
  final String argeNiteligi;
  final double yeterlilikOrani;
  final String farklilik;

  // 5. Plan Tabloları
  final List<GanttGorevModel> gorevler;
  final String kilometreTaslari;
  final String butceTutarliligi;

  // 6. Pazar
  final String ticarilesmePlani;
  final String pazarBuyuklugu; // TAM / SAM / SOM
  final String rakipler;

  // 7. Marka
  final String markaIsmi;
  final String konumlandirma;
  final String pazarlamaKanallari;

  const AnalizFormModel({
    this.fikirAdi = '',
    this.sektor = 'Yapay Zekâ',
    this.problem = '',
    this.cozum = '',
    this.hedefKitle = '',
    this.ekipUyeleri = const [],
    this.musteriVarMi = false,
    this.musteriDetay = '',
    this.hedefeYakinlikYuzdesi = 0.5,
    this.ciro = '0 ₺',
    this.karDurumu = 'Geliştirme Aşaması',
    this.argeNiteligi = '',
    this.yeterlilikOrani = 0.7,
    this.farklilik = '',
    this.gorevler = const [],
    this.kilometreTaslari = '',
    this.butceTutarliligi = '',
    this.ticarilesmePlani = '',
    this.pazarBuyuklugu = '',
    this.rakipler = '',
    this.markaIsmi = '',
    this.konumlandirma = '',
    this.pazarlamaKanallari = '',
  });

  AnalizFormModel copyWith({
    String? fikirAdi,
    String? sektor,
    String? problem,
    String? cozum,
    String? hedefKitle,
    List<EkipUyesiModel>? ekipUyeleri,
    bool? musteriVarMi,
    String? musteriDetay,
    double? hedefeYakinlikYuzdesi,
    String? ciro,
    String? karDurumu,
    String? argeNiteligi,
    double? yeterlilikOrani,
    String? farklilik,
    List<GanttGorevModel>? gorevler,
    String? kilometreTaslari,
    String? butceTutarliligi,
    String? ticarilesmePlani,
    String? pazarBuyuklugu,
    String? rakipler,
    String? markaIsmi,
    String? konumlandirma,
    String? pazarlamaKanallari,
  }) {
    return AnalizFormModel(
      fikirAdi: fikirAdi ?? this.fikirAdi,
      sektor: sektor ?? this.sektor,
      problem: problem ?? this.problem,
      cozum: cozum ?? this.cozum,
      hedefKitle: hedefKitle ?? this.hedefKitle,
      ekipUyeleri: ekipUyeleri ?? this.ekipUyeleri,
      musteriVarMi: musteriVarMi ?? this.musteriVarMi,
      musteriDetay: musteriDetay ?? this.musteriDetay,
      hedefeYakinlikYuzdesi:
          hedefeYakinlikYuzdesi ?? this.hedefeYakinlikYuzdesi,
      ciro: ciro ?? this.ciro,
      karDurumu: karDurumu ?? this.karDurumu,
      argeNiteligi: argeNiteligi ?? this.argeNiteligi,
      yeterlilikOrani: yeterlilikOrani ?? this.yeterlilikOrani,
      farklilik: farklilik ?? this.farklilik,
      gorevler: gorevler ?? this.gorevler,
      kilometreTaslari: kilometreTaslari ?? this.kilometreTaslari,
      butceTutarliligi: butceTutarliligi ?? this.butceTutarliligi,
      ticarilesmePlani: ticarilesmePlani ?? this.ticarilesmePlani,
      pazarBuyuklugu: pazarBuyuklugu ?? this.pazarBuyuklugu,
      rakipler: rakipler ?? this.rakipler,
      markaIsmi: markaIsmi ?? this.markaIsmi,
      konumlandirma: konumlandirma ?? this.konumlandirma,
      pazarlamaKanallari: pazarlamaKanallari ?? this.pazarlamaKanallari,
    );
  }

  factory AnalizFormModel.fromJson(Map<String, dynamic> json) {
    return AnalizFormModel(
      fikirAdi: json['fikirAdi'] as String? ?? '',
      sektor: json['sektor'] as String? ?? 'Yapay Zekâ',
      problem: json['problem'] as String? ?? '',
      cozum: json['cozum'] as String? ?? '',
      hedefKitle: json['hedefKitle'] as String? ?? '',
      ekipUyeleri: (json['ekipUyeleri'] as List<dynamic>?)
              ?.map((e) => EkipUyesiModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      musteriVarMi: json['musteriVarMi'] as bool? ?? false,
      musteriDetay: json['musteriDetay'] as String? ?? '',
      hedefeYakinlikYuzdesi:
          (json['hedefeYakinlikYuzdesi'] as num?)?.toDouble() ?? 0.5,
      ciro: json['ciro'] as String? ?? '0 ₺',
      karDurumu: json['karDurumu'] as String? ?? 'Geliştirme Aşaması',
      argeNiteligi: json['argeNiteligi'] as String? ?? '',
      yeterlilikOrani: (json['yeterlilikOrani'] as num?)?.toDouble() ?? 0.7,
      farklilik: json['farklilik'] as String? ?? '',
      gorevler: (json['gorevler'] as List<dynamic>?)
              ?.map((e) => GanttGorevModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      kilometreTaslari: json['kilometreTaslari'] as String? ?? '',
      butceTutarliligi: json['butceTutarliligi'] as String? ?? '',
      ticarilesmePlani: json['ticarilesmePlani'] as String? ?? '',
      pazarBuyuklugu: json['pazarBuyuklugu'] as String? ?? '',
      rakipler: json['rakipler'] as String? ?? '',
      markaIsmi: json['markaIsmi'] as String? ?? '',
      konumlandirma: json['konumlandirma'] as String? ?? '',
      pazarlamaKanallari: json['pazarlamaKanallari'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fikirAdi': fikirAdi,
      'sektor': sektor,
      'problem': problem,
      'cozum': cozum,
      'hedefKitle': hedefKitle,
      'ekipUyeleri': ekipUyeleri.map((e) => e.toJson()).toList(),
      'musteriVarMi': musteriVarMi,
      'musteriDetay': musteriDetay,
      'hedefeYakinlikYuzdesi': hedefeYakinlikYuzdesi,
      'ciro': ciro,
      'karDurumu': karDurumu,
      'argeNiteligi': argeNiteligi,
      'yeterlilikOrani': yeterlilikOrani,
      'farklilik': farklilik,
      'gorevler': gorevler.map((e) => e.toJson()).toList(),
      'kilometreTaslari': kilometreTaslari,
      'butceTutarliligi': butceTutarliligi,
      'ticarilesmePlani': ticarilesmePlani,
      'pazarBuyuklugu': pazarBuyuklugu,
      'rakipler': rakipler,
      'markaIsmi': markaIsmi,
      'konumlandirma': konumlandirma,
      'pazarlamaKanallari': pazarlamaKanallari,
    };
  }
}
