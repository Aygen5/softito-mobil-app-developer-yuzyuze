import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// [CrashlyticsServisi] - Firebase Çökme ve Hata Takip Servisi
///
/// Uygulamada meydana gelen beklenmedik çökmeleri, yakalanan hataları
/// ve kullanıcının işlem adımlarını (log/breadcrumb) Firebase Crashlytics
/// panosuna iletmek için kullanılır.
class CrashlyticsServisi {
  // Firebase Crashlytics kütüphanesinin tekil örneğine (instance) erişim sağlıyoruz
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Kullanıcı Bilgilerini Tanımlama
  ///
  /// Bir hata veya çökme meydana geldiğinde, bu sorunun hangi kullanıcıda
  /// ve hangi yetkide yaşandığını Firebase konsolunda filtreleyebilmek için
  /// kullanıcı ID'sini ve özel anahtarları (custom keys) Crashlytics'e bildirir.
  Future<void> kullaniciTanit({
    required String uid,
    required String rol,
  }) async {
    // Kullanıcının benzersiz kimlik numarasını tanımlar
    await _crashlytics.setUserIdentifier(uid);

    // Kullanıcının rolünü (örn: admin, standart üye) özel anahtar olarak ekler
    await _crashlytics.setCustomKey('rol', rol);

    // Hatanın hangi platformdan geldiğini belirten sabit özel anahtar ekler
    await _crashlytics.setCustomKey('platform', 'flutter');
  }

  /// Ayak İzi / İşlem Günlüğü (Breadcrumb) Ekleme
  ///
  /// Kullanıcının uygulama içindeki önemli hareketlerini (sayfa geçişi, buton tıklaması vb.) kaydeder.
  /// Çökme gerçekleştiğinde, bu loglar Firebase konsolundaki çökme raporunda
  /// hatadan hemen önceki adımlar olarak listelenir.
  void logEkle(String mesaj) {
    _crashlytics.log(mesaj);
  }

  /// Sessiz Hata Kaydetme (Try-Catch Blokları İçin)
  ///
  /// Uygulamanın aniden kapanmasına yol açmayan (non-fatal) ancak takip edilmesi gereken
  /// mantıksal hataları, API veya veritabanı istisnalarını hata iziyle (StackTrace) kaydeder.
  /// [fatal: false] parametresi uygulamanın çökmediğini belirtir.
  Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async {
    await _crashlytics.recordError(hata, stack, fatal: false);
  }

  /// Kasten Çökertme / Test Metodu
  ///
  /// Crashlytics bağlantısının ve raporlamasının doğru çalıştığını test etmek
  /// amacıyla uygulamada kasıtlı olarak anlık çökme (crash) oluşturur.
  void kastenCokert() {
    _crashlytics.crash();
  }
}
