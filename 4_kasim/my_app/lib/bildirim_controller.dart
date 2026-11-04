import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// ============================================================================
/// BİLDİRİM KONTROLCÜSÜ / YEREL BİLDİRİM YÖNETİCİSİ (LOCAL NOTIFICATIONS)
/// ============================================================================
/// Bu sınıf, cihaz üzerinde yerel (local) bildirimlerin oluşturulması, yapılandırılması
/// ve ekranda pop-up (banner) şeklinde gösterilmesini yönetir.
/// 
/// 📌 Neden Yerel Bildirime İhtiyaç Duyulur?
/// Firebase Cloud Messaging (FCM), uygulama arka planda veya kapalıyken bildirimleri
/// işletim sisteminin bildirim çubuğuna otomatik olarak basar. Ancak uygulama ÖN PLANDAYKEN
/// (foreground - kullanıcı uygulamayı aktif olarak kullanırken) gelen bildirimler varsayılan
/// olarak ekranda görünmez, yalnızca kod tarafında bir olay (event) olarak yakalanır.
/// Kullanıcının bu bildirimi görebilmesi için FlutterLocalNotificationsPlugin kullanılarak
/// ön planda anlık bir yerel bildirim tetiklenir.
class YerelBildirimYoneticisi {
  // Flutter yerel bildirim eklentisinin tekil örneği (singleton instance)
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      FlutterLocalNotificationsPlugin();

  /// ==========================================================================
  /// 1. KURULUM VE BAŞLATMA METODU
  /// ==========================================================================
  /// Uygulama ilk açıldığında (genellikle main() içinde veya servis başlangıcında)
  /// Android ve iOS platformlarına özel bildirim ikon ve izin ayarlarını tanımlar.
  static Future<void> kurulum() async {
    // Android için bildirim ikonu: AndroidManifest'teki app ikonu (@mipmap/ic_launcher) kullanılır.
    const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS (ve macOS) için Darwin bildirim başlangıç ayarları (varsayılan izinler ve bildirim davranışları)
    const iosAyarlar = DarwinInitializationSettings();

    // Platform ayarlarını ortak InitializationSettings nesnesi altında birleştiriyoruz.
    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar,
    );

    // Eklentiyi belirtilen ayarlarla başlatıyoruz.
    await _yerelBildirim.initialize(settings: ayarlar);
  }

  /// ==========================================================================
  /// 2. BİLDİRİM GÖSTERME METODU
  /// ==========================================================================
  /// FCM'den gelen RemoteMessage nesnesini alır ve Android/iOS bildirim çubuğunda
  /// sesli, titreşimli ve yüksek öncelikli bir banner olarak gösterir.
  static Future<void> bildirimGoster(RemoteMessage message) async {
    // Android 8.0 (API 26) ve üzeri sürümlerde bildirimlerin bir kanala (Notification Channel)
    // bağlı olması ZORUNLUDUR. Kanal ayarları bildirim sesini, önemini ve titreşimini belirler.
    const androidDetay = AndroidNotificationDetails(
      'softito_kanal_id',          // Kanal ID: Sistemde benzersiz olmalıdır
      'Softito Bildirimleri',     // Kanal Adı: Kullanıcının telefon ayarlarında gördüğü başlık
      importance: Importance.max, // Bildirimin ekranda açılır kutu (heads-up) olarak çıkmasını sağlar
      priority: Priority.high,    // Yüksek öncelik
      playSound: true,            // Bildirim geldiğinde bildirim sesi çalar
    );

    // Bildirim detaylarını paketliyoruz
    const detaylar = NotificationDetails(android: androidDetay);

    // Yerel bildirimi ekranda gösteriyoruz:
    // - id: Her bildirimin benzersiz bir kimliği olmalıdır (aynı id gelirse bildirim güncellenir).
    //       Burada message.hashCode kullanılarak her mesaja özel tekil bir tam sayı üretilir.
    // - title: FCM bildiriminin başlığı (boşsa yedek metin kullanılır).
    // - body: FCM bildiriminin ana gövde metni.
    await _yerelBildirim.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'Yeni Bildirim',
      body: message.notification?.body ?? '',
      notificationDetails: detaylar,
    );
  }
}
