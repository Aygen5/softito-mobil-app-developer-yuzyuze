import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// ============================================================================
/// FIREBASE STORAGE SERVİSİ (BULUT DEPOLAMA KATMANI)
/// ============================================================================
/// Bu servis, cihazdaki yerel dosyaların (fotoğraf, video, belge vb.)
/// Firebase Cloud Storage bulut depolama havuzuna yüklenmesini yönetir.
/// 
/// 📌 Firestore vs. Firebase Storage Farkı:
/// - Cloud Firestore: Yapılandırılmış JSON/NoSQL metin verilerini (öğrenci adı, mesaj, fiyat vb.) tutar.
/// - Firebase Storage: Büyük boyutlu ikili (binary) medya dosyalarını (JPEG, PNG, PDF vb.) saklar.
class StorageServisi {
  // Firebase Storage eklentisinin ana örneği (varsayılan bucket'a bağlanır)
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// ==========================================================================
  /// DOSYA YÜKLEME GÖREVİ BAŞLATMA (UPLOAD TASK)
  /// ==========================================================================
  /// [hedefDizin]: Buluttaki klasör yolu (Örn: 'kullanici_resimleri' veya 'profil')
  /// [dosya]: Cihazdan seçilen fiziksel dosya (File)
  /// [dosyaAdi]: Bulutta kaydedilecek tekil dosya adı (Örn: 'avatar_123.jpg')
  /// 
  /// 🔄 Dönüş Değeri (UploadTask):
  /// Bir Future yerine `UploadTask` döndürülmesi sayede yükleme işlemi duraklatılabilir,
  /// iptal edilebilir veya anlık ilerleme (progress bar) akışı UI'da dinlenebilir.
  UploadTask yuklemeBaslat({
    required String hedefDizin,
    required File dosya,
    required String dosyaAdi,
  }) {
    // Bulut üzerindeki hedef dosya yolunu temsil eden Reference nesnesi oluşturuluyor.
    // Örnek bulut yolu: gs://proje-id.appspot.com/hedefDizin/dosyaAdi.jpg
    final Reference referans = _storage.ref().child(hedefDizin).child(dosyaAdi);

    // Dosyaya ait meta verileri tanımlıyoruz:
    // - contentType: Tarayıcıların ve istemcilerin dosya türünü tanımasını sağlar (MIME type).
    // - customMetadata: Dosyaya eklenen özel anahtar-değer bilgileri (yükleyen kişi, versiyon vb.).
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'yukleyen': 'çervo'},
    );

    // putFile metodu asenkron yükleme işlemini başlatır ve takip edilebilir bir görev (UploadTask) döner.
    final UploadTask task = referans.putFile(dosya, metadata);

    // Yükleme ilerlemesini (progress) anlık olarak dinlemek için Stream dinleyicisi (listener) ekliyoruz.
    // Her bayt transferinde tetiklenir:
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      // Aktarılan bayt miktarını toplam bayta oranlayarak %0 - %100 arası yükleme yüzdesini hesaplıyoruz.
      final double yuzde =
          (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      print('Yükleme Yüzdesi: %${yuzde.toStringAsFixed(1)}');
    });

    // Görev nesnesi, çağıran widget'a geri döner; böylece UI'da CircularProgressIndicator
    // veya LinearProgressIndicator ile görselleştirilebilir.
    return task;
  }
}
