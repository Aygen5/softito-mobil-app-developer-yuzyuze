import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// ============================================================================
/// FIREBASE STORAGE & MEDYA YÖNETİM SERVİSİ
/// ============================================================================
/// Bu servis, mobil uygulamada hem cihazdan medya (görsel) seçimini
/// hem de seçilen medyanın Firebase Cloud Storage bulutuna yüklenmesi,
/// indirme bağlantısının (Download URL) alınması ve silinmesi işlemlerini
/// uçtan uca yöneten kapsamlı servis sınıfıdır.
class StorageServisi {
  // Firebase Cloud Storage örneği
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Kamera ve galeri erişimi için ImagePicker eklentisi
  final ImagePicker _picker = ImagePicker();

  /// ==========================================================================
  /// 1. GÖRSEL SEÇME (KAMERA VEYA GALERİ)
  /// ==========================================================================
  /// [kameradan]: True ise doğrudan cihaz kamerasını açar, False ise galeriyi açar.
  /// 
  /// 💡 Optimizasyon:
  /// - `imageQuality: 80`: Görsel sıkıştırma oranı
  /// - `maxWidth: 1200`: Bellek tüketimini ve bulut yükleme süresini düşürmek için sınırlandırma
  Future<File?> gorselSec({bool kameradan = false}) async {
    final XFile? xFile = await _picker.pickImage(
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    // Kullanıcı işlem yapmadan vazgeçtiyse null döner
    if (xFile == null) return null;

    // Seçilen resmin dosya yolundan standart Dart File nesnesi üretilir
    return File(xFile.path);
  }

  /// ==========================================================================
  /// 2. BULUTA DOSYA YÜKLEME (UPLOAD TASK)
  /// ==========================================================================
  /// Seçilen fiziksel dosyayı Firebase Storage'ın belirtilen klasörüne yükler.
  /// 
  /// [dosya]: Yüklenecek yerel File nesnesi
  /// [dosyaAdi]: Buluttaki benzersiz dosya adı (Örn: 'foto_123.png')
  /// [klasor]: Saklanacağı dizin (Varsayılan: 'yuklemeler')
  /// 
  /// 🔄 Geri Dönüş: `UploadTask` nesnesi döndürülerek yüklemenin ilerleme yüzdesi
  /// (progress) veya tamamlanma anı çağıran widget tarafından dinlenebilir.
  UploadTask yuklemeBaslat({
    required File dosya,
    required String dosyaAdi,
    String klasor = 'yuklemeler',
  }) {
    // Bulut üzerindeki konumu belirten Reference nesnesi oluşturuluyor
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');

    // Dosyaya ait meta veriler tanımlanıyor:
    // - contentType: Web ve mobil tarayıcıların dosyayı doğru işlemesi için MIME türü
    // - customMetadata: Yükleyen bilgisi gibi özel denetim bilgileri
    final metadata = SettableMetadata(
      contentType: 'image/png',
      customMetadata: {'ekleyen': 'meltem'},
    );

    // putFile metodu arka planda asenkron yüklemeyi başlatır
    return ref.putFile(dosya, metadata);
  }

  /// ==========================================================================
  /// 3. İNDİRME BAĞLANTISI (DOWNLOAD URL) ALMA
  /// ==========================================================================
  /// Yüklenen dosyanın internetten herkese açık (veya izinli) şekilde
  /// erişilebilen HTTPS bağlantısını (URL) getirir.
  /// Bu URL genellikle Firestore veritabanına kaydedilir (örn. kullanıcı avatarUrl alanı).
  Future<String> urlGetir(Reference ref) async {
    return await ref.getDownloadURL();
  }

  /// ==========================================================================
  /// 4. BULUTTAN DOSYA SİLME (DELETE FROM STORAGE)
  /// ==========================================================================
  /// Belirtilen dosya yolundaki (Örn: 'yuklemeler/foto_123.png') medyayı
  /// Firebase Storage havuzundan kalıcı olarak siler.
  Future<void> dosyaSil(String dosyaYolu) async {
    final Reference ref = _storage.ref().child(dosyaYolu);
    await ref.delete();
  }
}
