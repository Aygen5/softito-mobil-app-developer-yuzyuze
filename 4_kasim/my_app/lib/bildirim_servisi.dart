import 'package:firebase_messaging/firebase_messaging.dart';

/// ============================================================================
/// FIREBASE CLOUD MESSAGING (FCM) - ARKA PLAN İŞLEYİCİSİ (BACKGROUND HANDLER)
/// ============================================================================
/// Uygulama tamamen kapalıyken (terminated) veya arka plandayken (background)
/// gelen FCM mesajlarını dinleyebilmek için bu fonksiyonun mutlaka:
/// 1. Sınıf dışında (top-level / global) tanımlanması gerekir.
/// 2. `@pragma('vm:entry-point')` etiketiyle işaretlenmesi gerekir; böylece Dart VM
///    ve Flutter derleyicisi (tree-shaking) bu fonksiyonu "kullanılmıyor" zannedip silmez.
///    Çünkü uygulama kapalıyken işletim sistemi ayrı bir Dart izolatı (isolate) açarak
///    bu fonksiyonu doğrudan çağırır.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Arka planda gelen mesajın başlığını konsola yazdırıyoruz.
  // Gerçek projelerde burada yerel veritabanına kayıt veya durum güncellemesi yapılabilir.
  print('Arka planda bildirim geldi: ${message.notification?.title}');
}

/// ============================================================================
/// BİLDİRİM SERVİSİ (FCM SERVİS KATMANI)
/// ============================================================================
/// Firebase Cloud Messaging işlemlerini başlatan, izinleri talep eden
/// ve sunucunun bu cihaza mesaj gönderebilmesi için gereken tekil FCM Token'ı alan servis.
class BildirimServisi {
  // Firebase Messaging eklentisinin ana örneği
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Servisin başlatılması, izin süreçleri ve Token alma adımları
  Future<void> baslat() async {
    /// ------------------------------------------------------------------------
    /// 1. BİLDİRİM İZNİ İSTEME (REQUEST PERMISSION)
    /// ------------------------------------------------------------------------
    /// iOS ve Android 13+ (API seviyesi 33+) cihazlarda kullanıcıdan bildirim
    /// izni çalışma anında (runtime permission) açıkça istenmelidir.
    /// - alert: Ekranda görsel uyarı gösterilsin mi?
    /// - badge: Uygulama ikonu üzerinde okunmamış bildirim sayısı rozeti çıksın mı?
    /// - sound: Bildirim uyarısında ses çalınsın mı?
    NotificationSettings ayarlar = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// İzin durumunu kontrol ediyoruz:
    /// - authorized: Kullanıcı izin verdi
    /// - provisional: Geçici / sessiz bildirim izni (iOS)
    /// - denied: Kullanıcı izni reddetti
    if (ayarlar.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı bildirim izni verdi');
    } else {
      print('Kullanıcı bildirim izni vermedi');
    }

    /// ------------------------------------------------------------------------
    /// 2. FCM REGISTRATION TOKEN (CİHAZ BELİRTEÇ ANAHTARI) ALMA
    /// ------------------------------------------------------------------------
    /// FCM Token, Firebase'in bu cihazı ve bu uygulamayı dünyadaki diğer tüm
    /// cihazlardan ayırt etmesini sağlayan uzun ve benzersiz bir kimlik dizisidir.
    /// 
    /// 💡 Nasıl Kullanılır?
    /// - Bu Token uygulamanın ilk açılışında alınır.
    /// - Backend / API sunucunuza (veya veritabanına) gönderilerek kullanıcıyla eşleştirilir.
    /// - Bir bildirim atılacağı zaman Firebase Admin SDK bu Token'a hedefleme yapar.
    /// - Firebase Console üzerinden test bildirimi gönderirken de bu Token kullanılır.
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }
}
