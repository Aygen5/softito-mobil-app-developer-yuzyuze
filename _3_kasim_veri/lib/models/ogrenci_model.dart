import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore üzerindeki öğrenci verisini temsil eden model sınıfı.
class OgrenciModel {
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModel({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  /// Firestore dökümanından (DocumentSnapshot) Dart modeline parse işlemi
  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    final veri = doc.data() as Map<String, dynamic>? ?? {};

    return OgrenciModel(
      id: doc.id,
      adSoyad: veri['adSoyad'] as String? ?? 'İsimsiz Öğrenci',
      projeAdi: veri['projeAdi'] as String? ?? 'Proje Belirtilmedi',
      notu: (veri['notu'] as num?)?.toInt() ?? 0,
      kayitTarihi: (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Firestore'a kayıt ederken veya güncellerken Map formatına dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'adSoyad': adSoyad,
      'projeAdi': projeAdi,
      'notu': notu,
      'kayitTarihi': Timestamp.fromDate(kayitTarihi),
    };
  }

  /// Mevcut modelin bir kopyasını alıp belirli alanları güncellemek için yardımcı metot
  OgrenciModel copyWith({
    String? id,
    String? adSoyad,
    String? projeAdi,
    int? notu,
    DateTime? kayitTarihi,
  }) {
    return OgrenciModel(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      projeAdi: projeAdi ?? this.projeAdi,
      notu: notu ?? this.notu,
      kayitTarihi: kayitTarihi ?? this.kayitTarihi,
    );
  }
}
