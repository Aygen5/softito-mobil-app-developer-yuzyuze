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
  /// Bildirim izinlerini talep eder, yerel bildirim motorunu kurar,
  /// ön plan ve arka plan dinleyicilerini devreye sokar.
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _yerelBildirimGoster(message);
      if (onMesajGeldi != null) {
        onMesajGeldi!(message);
      }
    });

    // 4. Arka Plan Mesaj Dinleyicisi (Background Message Handler)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// ==========================================================================
  /// 2. TOPIC (KONU) ABONELİĞİ YÖNETİMİ
  /// ==========================================================================
  /// Belirtilen bir konuya abone olma
  Future<void> konuyaAboneOl(String konu) async {
    await _firebaseMessaging.subscribeToTopic(konu);
    print('$konu konusuna başarıyla abone olundu.');
  }

  /// Geriye dönük uyumluluk için alias metot
  Future<void> konudanAboneOl(String konu) async {
    await konuyaAboneOl(konu);
  }

  /// Belirtilen bir konunun aboneliğinden çıkma
  Future<void> konudanAyril(String konu) async {
    await _firebaseMessaging.unsubscribeFromTopic(konu);
    print('$konu konusunun aboneliğinden ayrılındı.');
  }

  /// ==========================================================================
  /// 3. CİHAZIN FCM TOKEN BİLGİSİNİ ALMA
  /// ==========================================================================
  Future<String?> tokenAl() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (_) {
      return null;
    }
  }

  /// ==========================================================================
  /// 4. YEREL BİLDİRİM GÖSTERME (HEADS-UP BANNER)
  /// ==========================================================================
  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
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

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }
}
