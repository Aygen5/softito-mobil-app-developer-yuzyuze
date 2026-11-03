import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciModel {
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  OgrenciModel({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    final veri = doc.data() as Map<String, dynamic>? ?? {};

    return OgrenciModel(
      id: doc.id,
      adSoyad: veri['adSoyad'] as String? ?? 'İsimsiz öğrenci',
      projeAdi: veri['projeAdi'] as String? ?? 'Öğrencinin henüz projesi yok.',
      notu: (veri['notu'] as num?)?.toInt() ?? 0,
      kayitTarihi: (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class FireStoreOgrenciServisi{
  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance.collection('ogrenciler');
  Future<void> ogrenciEkle ({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  })
  async {
    try {
      await _ogrencilerKoleksiyonu.add({
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        'kayitTarihi': FieldValue.serverTimestamp(),
      });
      print('Öğrenci Başarıyla Kaydedildi');
     }
     catch (e) {
      print ('Öğrenci ekleme başarısız $e');
      rethrow; 
    }
  }

  Future <void> ogrenciIdIleKaydet ({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  })
  async {
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad':adSoyad,
      'projeAdi':projeAdi,
      'guncellemeTarihi': FieldValue.serverTimestamp(),
    }, SetOptions(merge:true));
  }

  Future<List<OgrenciModel>> tumOgrencileriGetir() async {
    try {
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu.orderBy('notu', descending: true).get();
      return snapshot.docs.map((doc)=>OgrenciModel.fromFireStore(doc)).toList();
    }
    catch (e) {
      print ("Veri çekme hatası: $e");
      return [];
    }
  }

  Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async {
    await _ogrencilerKoleksiyonu.doc(documanId).update({
      'notu': yeniNot,
      'sonDuzenleme':FieldValue.serverTimestamp(),
    });
  }

  Future<void> ogrenciSil(String documanId) async {
    await _ogrencilerKoleksiyonu.doc(documanId).delete();
    print('$documanId referanslı veri tamamen silindi.');

  }
  
  
}