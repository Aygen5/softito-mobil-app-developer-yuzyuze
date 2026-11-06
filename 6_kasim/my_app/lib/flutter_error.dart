import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// [HataServisi] - Firebase Crashlytics Servisi
///
/// Uygulama içerisinde meydana gelen beklenmedik çökmeleri (crash),
/// yakalanan hataları ve kullanıcı adımlarını (breadcrumbs) uzaktan
/// takip etmek ve analiz etmek amacıyla kullanılan servis sınıfıdır.
class HataServisi {
  // FirebaseCrashlytics tekil örneği (Singleton instance)
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Kullanıcı Bilgilerini Tanımlama
  ///
  /// Bir çökme yaşandığında hatanın hangi kullanıcıda, hangi kullanıcı rolünde
  /// veya üyelik paketinde gerçekleştiğini Firebase konsolunda görebilmek için
  /// özel tanımlayıcılar (Identifier ve Custom Keys) atar.
  Future<void> kuulaniciTanit({
    required String uid,
    required String rol,
    required String paket,
  }) async {
    // Kullanıcının benzersiz kimliğini (ID) Crashlytics'e bildirir
    await _crashlytics.setUserIdentifier(uid);
    // Özel anahtar-değer çiftleri ekleyerek hatayı filtrelemeyi kolaylaştırır
    await _crashlytics.setCustomKey("kullanici_rolu", rol);
    await _crashlytics.setCustomKey("uyelik_tipi", paket);
  }

  /// Ayak İzi (Breadcrumbs) Bırakma
  ///
  /// Kullanıcının uygulama içinde yaptığı önemli adımları kaydeder.
  /// Çökme anında kullanıcının son olarak hangi sayfaları gezdiği veya
  /// hangi işlemleri yaptığı raporun içinde "Breadcrumb log" olarak görünür.
  void ayakIziBirak(String adim) {
    _crashlytics.log('kullanıcı işlem: $adim');
  }

  /// Sessiz Hata Kaydetme (Try-Catch Blokları İçin)
  ///
  /// Uygulamanın çökmediği fakat mantıksal veya veri tabanı gibi kritik
  /// bir hata alındığı durumlarda hatayı ve yığın izini (StackTrace)
  /// Crashlytics sunucusuna sessizce raporlar.
  /// [fatal: true] parametresi bu hatanın kritik bir hata olduğunu belirtir.
  Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async {
    await _crashlytics.recordError(hata, stack, fatal: true);
  }

  /// Crashlytics Test Butonu
  ///
  /// Firebase Crashlytics entegrasyonunun başarıyla çalışıp çalışmadığını
  /// test etmek amacıyla kasıtlı olarak bir çökme (crash) fırlatan örnek buton.
  Widget cokmeTestButonu() {
    return ElevatedButton(
      onPressed: () {
        // Uygulamayı kasıtlı olarak çökerterek Firebase konsoluna çökme raporu iletir
        _crashlytics.crash();
      },
      child: const Text('Çökme Testi Gönder'),
    );
  }
}
