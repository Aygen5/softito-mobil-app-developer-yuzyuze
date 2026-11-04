import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ============================================================================
/// FIREBASE CLOUD MESSAGING (FCM) - ARKA PLAN İŞLEYİCİSİ (BACKGROUND HANDLER)
/// ============================================================================
/// Uygulama arka plandayken veya tamamen kapalıyken (killed/terminated) gelen
/// bildirimleri yakalayan global fonksiyon.
/// 
/// ⚠️ Dikkat Edilmesi Gereken Kurallar:
/// 1. Sınıf dışında (top-level) olmalıdır.
/// 2. `@pragma('vm:entry-point')` anatasyonu ile işaretlenmelidir (Dart derleyicisinin
///    tree-shaking ile bu fonksiyonu koddan temizlemesini önler).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Arka planda bildirim geldi: ${message.notification?.title}');
}

/// ============================================================================
/// GELİŞMİŞ FCM VE YEREL BİLDİRİM SERVİSİ (FCM NOTIFICATION SERVICE)
/// ============================================================================
/// Bu servis; Firebase Cloud Messaging (FCM) bildirim izinlerini, konu aboneliklerini
/// (Topics), ön planda bildirim yakalamayı ve yerel bildirim gösterme işlemlerini
/// tek bir çatı altında toplayan gelişmiş servis katmanıdır.
class FcmBildirimServisi {
  // Firebase Messaging örneği (bulut mesajlaşma motoru)
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Flutter yerel bildirim eklentisi (ön planda banner göstermek için)
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Ön planda mesaj geldiğinde arayüze (UI) haber vermek için opsiyonel geri çağırma (callback)
  Function(RemoteMessage message)? onMesajGeldi;

  /// ==========================================================================
  /// 1. BİLDİRİM SERVİSİNİ BAŞLATMA VE YAPILANDIRMA
  /// ==========================================================================
  /// Bildirim izinlerini talep eder, yerel bildirim motorunu kurar ve
  /// ön plan dinleyicisini (Foreground Listener) devreye sokar.
  Future<void> baslat() async {
    // 1. Kullanıcıdan bildirim izni talep etme (iOS ve Android 13+)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Yerel bildirim eklentisinin platform ayarlarını tanımlama
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Yerel bildirim motorunu başlatıyoruz
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // 3. Ön Plan Mesaj Dinleyicisi (Foreground Stream Listener)
    // Uygulama açık ve ekrandayken bir FCM mesajı geldiğinde tetiklenir:
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Bildirimi kullanıcıya açılır pencere (heads-up notification) olarak göster
      _yerelBildirimGoster(message);

      // Eğer bir UI dinleyicisi tanımlanmışsa (kart listesi gibi), mesaja haber ver
      if (onMesajGeldi != null) {
        onMesajGeldi!(message);
      }
    });
  }

  /// ==========================================================================
  /// 2. TOPIC (KONU) ABONELİĞİ YÖNETİMİ
  /// ==========================================================================
  /// FCM Konuları (Topics); tek tek kullanıcı token'ları ile uğraşmadan, belirli
  /// bir gruba (Örn: 'tum_sinif', 'kampanyalar', 'duyurular') toplu bildirim (broadcast)
  /// göndermeyi sağlayan çok güçlü bir mekanizmadır.

  /// Belirtilen bir konuya abone olma
  Future<void> konudanAboneOl(String konu) async {
    // Kullanıcı bu konuya abone olduğunda, sunucu o konuya mesaj attığında cihaz bildirim alır.
    await _firebaseMessaging.subscribeToTopic(konu);
    print('$konu konusuna başarıyla abone olundu.');
  }

  /// Belirtilen bir konunun aboneliğinden çıkma
  Future<void> konudanAyrıl(String konu) async {
    // Kullanıcı konudan çıktığında artık bu grup bildirimlerini almaz.
    await _firebaseMessaging.unsubscribeFromTopic(konu);
    print('$konu konusunun aboneliğinden ayrılındı.');
  }

  /// Cihazın güncel FCM Token bilgisini döndürür
  Future<String?> tokenAl() async {
    return await _firebaseMessaging.getToken();
  }

  /// ==========================================================================
  /// 3. YEREL BİLDİRİM GÖSTERME (HEADS-UP BANNER)
  /// ==========================================================================
  /// Ön planda gelen FCM mesajını sistem bildirim tepsisinde gösteren yardımcı metot.
  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    // Android bildirim kanalı yapılandırması
    const androidDetails = AndroidNotificationDetails(
      'kanal_id',
      'Kanal Adı',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Yerel bildirimi patlatıyoruz
    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,                     // Benzersiz ID
      message.notification?.title ?? '',   // Bildirim Başlığı
      message.notification?.body ?? '',    // Bildirim Gövdesi
      notificationDetails,
    );
  }
}
