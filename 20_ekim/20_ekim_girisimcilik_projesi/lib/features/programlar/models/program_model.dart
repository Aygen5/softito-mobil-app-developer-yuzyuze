import 'package:flutter/foundation.dart';

enum ProgramKategori {
  hibe('Hibe Programları'),
  devlet('Devlet Destekleri'),
  yurtdisi('Yurtdışı Destekleri'),
  ozelSektor('Özel Sektör Destekleri'),
  kulucka('Kuluçka & Hızlandırma');

  final String baslik;
  const ProgramKategori(this.baslik);
}

enum ProgramDurum {
  acik('Başvuruya Açık'),
  yakinda('Yakında Başlıyor'),
  kapandi('Başvuru Kapandı');

  final String baslik;
  const ProgramDurum(this.baslik);
}

@immutable
class ProgramModel {
  final String id;
  final String ad;
  final String kurum;
  final ProgramKategori kategori;
  final String destekTutari;
  final List<String> uygunlukSartlari;
  final String sonBasvuruTarihi;
  final ProgramDurum durum;
  final List<String> basvuruAdimlari;
  final String aciklama;
  final bool takvimeEklendi;

  const ProgramModel({
    required this.id,
    required this.ad,
    required this.kurum,
    required this.kategori,
    required this.destekTutari,
    required this.uygunlukSartlari,
    required this.sonBasvuruTarihi,
    required this.durum,
    required this.basvuruAdimlari,
    required this.aciklama,
    this.takvimeEklendi = false,
  });

  ProgramModel copyWith({
    String? id,
    String? ad,
    String? kurum,
    ProgramKategori? kategori,
    String? destekTutari,
    List<String>? uygunlukSartlari,
    String? sonBasvuruTarihi,
    ProgramDurum? durum,
    List<String>? basvuruAdimlari,
    String? aciklama,
    bool? takvimeEklendi,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      kurum: kurum ?? this.kurum,
      kategori: kategori ?? this.kategori,
      destekTutari: destekTutari ?? this.destekTutari,
      uygunlukSartlari: uygunlukSartlari ?? this.uygunlukSartlari,
      sonBasvuruTarihi: sonBasvuruTarihi ?? this.sonBasvuruTarihi,
      durum: durum ?? this.durum,
      basvuruAdimlari: basvuruAdimlari ?? this.basvuruAdimlari,
      aciklama: aciklama ?? this.aciklama,
      takvimeEklendi: takvimeEklendi ?? this.takvimeEklendi,
    );
  }

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String? ?? '',
      ad: json['ad'] as String? ?? '',
      kurum: json['kurum'] as String? ?? '',
      kategori: ProgramKategori.values.firstWhere(
        (e) => e.name == json['kategori'],
        orElse: () => ProgramKategori.hibe,
      ),
      destekTutari: json['destekTutari'] as String? ?? '',
      uygunlukSartlari: (json['uygunlukSartlari'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sonBasvuruTarihi: json['sonBasvuruTarihi'] as String? ?? '',
      durum: ProgramDurum.values.firstWhere(
        (e) => e.name == json['durum'],
        orElse: () => ProgramDurum.acik,
      ),
      basvuruAdimlari: (json['basvuruAdimlari'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aciklama: json['aciklama'] as String? ?? '',
      takvimeEklendi: json['takvimeEklendi'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'kurum': kurum,
      'kategori': kategori.name,
      'destekTutari': destekTutari,
      'uygunlukSartlari': uygunlukSartlari,
      'sonBasvuruTarihi': sonBasvuruTarihi,
      'durum': durum.name,
      'basvuruAdimlari': basvuruAdimlari,
      'aciklama': aciklama,
      'takvimeEklendi': takvimeEklendi,
    };
  }
}
