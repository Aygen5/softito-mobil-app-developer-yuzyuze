import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:_3_kasim_veri/models/ogrenci_model.dart';

/// Öğrenci veri işlemleri için sözleşme (Interface)
abstract class IOgrenciServisi {
  Stream<List<OgrenciModel>> ogrencileriCanliDinle();
  Future<List<OgrenciModel>> tumOgrencileriGetir();
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  });
  Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot);
  Future<void> ogrenciSil(String documanId);
}

/// Cloud Firestore ile çalışan somut servis sınıfı
class FirestoreOgrenciServisi implements IOgrenciServisi {
  final CollectionReference _ogrencilerKoleksiyonu =
      FirebaseFirestore.instance.collection('ogrenciler');

  /// Öğrencileri notuna göre azalan sırayla anlık (real-time stream) olarak dinler.
  /// Gelen dökümanları doğrudan OgrenciModel listesine parse eder.
  @override
  Stream<List<OgrenciModel>> ogrencileriCanliDinle() {
    return _ogrencilerKoleksiyonu
        .orderBy('notu', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OgrenciModel.fromFireStore(doc))
          .toList();
    });
  }

  /// Tüm öğrencileri tek seferlik getirir
  @override
  Future<List<OgrenciModel>> tumOgrencileriGetir() async {
    try {
      final QuerySnapshot snapshot =
          await _ogrencilerKoleksiyonu.orderBy('notu', descending: true).get();
      return snapshot.docs
          .map((doc) => OgrenciModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Yeni bir öğrenci kaydı oluşturur (adSoyad, projeAdi, notu, sunucu zaman damgası)
  @override
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  }) async {
    try {
      await _ogrencilerKoleksiyonu.add({
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        'kayitTarihi': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Öğrencinin sadece notunu günceller
  @override
  Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async {
    try {
      await _ogrencilerKoleksiyonu.doc(documanId).update({
        'notu': yeniNot,
        'sonDuzenleme': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Belirtilen ID'ye sahip öğrenci dokümanını Firestore'dan siler
  @override
  Future<void> ogrenciSil(String documanId) async {
    try {
      await _ogrencilerKoleksiyonu.doc(documanId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
