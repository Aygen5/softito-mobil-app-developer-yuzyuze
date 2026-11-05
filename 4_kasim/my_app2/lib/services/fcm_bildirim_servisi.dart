import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Arka planda bildirim geldi: ${message.notification?.title ?? message.data['title']}');
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

  // Android 8.0+ için yüksek öncelikli bildirim kanalı (Heads-up banner ve ses için şarttır)
  static const AndroidNotificationChannel kanal = AndroidNotificationChannel(
    'high_importance_channel', // Kanal benzersiz ID'si
    'Yüksek Öncelikli Bildirimler', // Kullanıcının ayarlarda göreceği kanal adı
    description: 'Bu kanal Firebase ve test anlık bildirimleri için kullanılır.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  // Mesaj geldiğinde arayüze (UI) haber vermek için opsiyonel geri çağırma (callback)
  Function(RemoteMessage message)? onMesajGeldi;

  // Bildirime tıklandığında tetiklenen callback
  Function(String? payload)? onBildirimeTiklandi;

  /// ==========================================================================
  /// 1. BİLDİRİM SERVİSİNİ BAŞLATMA VE YAPILANDIRMA
  /// ==========================================================================
  /// Bildirim izinlerini talep eder, yerel bildirim motorunu kurar,
  /// ön plan ve arka plan dinleyicilerini devreye sokar.
  Future<void> baslat() async {
    // 1. Firebase Messaging izin talebi (iOS ve Android)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // 2. Android 13+ (API 33+) için yerel bildirim izni talebi ve Bildirim Kanalı kaydı
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Android 13+ bildirim açılır penceresini tetikler
      await androidImplementation.requestNotificationsPermission();
      // Yüksek öncelikli bildirim kanalını Android sistemine tanıtır
      await androidImplementation.createNotificationChannel(kanal);
    }

    // 3. Yerel bildirim eklentisinin platform ayarlarını tanımlama
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Yerel bildirim motorunu başlatıyoruz ve tıklama olayını dinliyoruz
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (onBildirimeTiklandi != null) {
          onBildirimeTiklandi!(response.payload);
        }
      },
    );

    // 4. Ön Plan Mesaj Dinleyicisi (Foreground Stream Listener)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Ön planda mesaj alındı: ${message.notification?.title}");
      _fcmMesajiniYerelGoster(message);
      if (onMesajGeldi != null) {
        onMesajGeldi!(message);
      }
    });

    // 5. Arka plandayken bildirime tıklandığında uygulamayı açma dinleyicisi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Arka plan bildirimine tıklandı: ${message.notification?.title}");
      if (onMesajGeldi != null) {
        onMesajGeldi!(message);
      }
    });

    // 6. Uygulama tamamen kapalıyken bildirime tıklanarak açıldıysa
    final baslangicMesaji = await _firebaseMessaging.getInitialMessage();
    if (baslangicMesaji != null) {
      debugPrint("Uygulama bildirimle açıldı: ${baslangicMesaji.notification?.title}");
      if (onMesajGeldi != null) {
        onMesajGeldi!(baslangicMesaji);
      }
    }

    // 7. Arka Plan Mesaj Dinleyicisi (Background Message Handler)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// ==========================================================================
  /// 2. TOPIC (KONU) ABONELİĞİ YÖNETİMİ
  /// ==========================================================================
  /// Belirtilen bir konuya abone olma
  Future<void> konuyaAboneOl(String konu) async {
    await _firebaseMessaging.subscribeToTopic(konu);
    debugPrint('$konu konusuna başarıyla abone olundu.');
  }

  /// Geriye dönük uyumluluk için alias metot
  Future<void> konudanAboneOl(String konu) async {
    await konuyaAboneOl(konu);
  }

  /// Belirtilen bir konunun aboneliğinden çıkma
  Future<void> konudanAyril(String konu) async {
    await _firebaseMessaging.unsubscribeFromTopic(konu);
    debugPrint('$konu konusunun aboneliğinden ayrılındı.');
  }

  /// ==========================================================================
  /// 3. CİHAZIN FCM TOKEN BİLGİSİNİ ALMA
  /// ==========================================================================
  Future<String?> tokenAl() async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint("FCM Token alındı: $token");
      return token;
    } catch (e) {
      debugPrint("Token alma hatası: $e");
      return null;
    }
  }

  /// ==========================================================================
  /// 4. YEREL BİLDİRİM GÖSTERME (HEADS-UP BANNER)
  /// ==========================================================================
  Future<void> yerelBildirimGoster({
    required String baslik,
    required String icerik,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      kanal.id,
      kanal.name,
      channelDescription: kanal.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      baslik,
      icerik,
      notificationDetails,
      payload: payload,
    );
  }

  /// FCM'den gelen RemoteMessage'ı ekranda heads-up banner olarak gösterir
  Future<void> _fcmMesajiniYerelGoster(RemoteMessage message) async {
    final baslik = message.notification?.title ??
        message.data['title'] ??
        'Yeni Bildirim';
    final icerik = message.notification?.body ??
        message.data['body'] ??
        message.data['message'] ??
        'Yeni bir bildiriminiz var.';

    await yerelBildirimGoster(
      baslik: baslik,
      icerik: icerik,
      payload: message.data.toString(),
    );
  }

  /// Uygulama içinden bildirim mekanizmasının sorunsuz çalıştığını test etmek için
  Future<void> testBildirimiGoster({String? baslik, String? icerik}) async {
    await yerelBildirimGoster(
      baslik: baslik ?? 'Test Bildirimi 🚀',
      icerik: icerik ?? 'Bildirim sisteminiz başarıyla ve aktif olarak çalışıyor!',
      payload: 'test_notification',
    );
  }
}
