import 'package:firebase_remote_config/firebase_remote_config.dart';

/// [RemoteConfigServisi] - Firebase Remote Config Servisi
///
/// Uygulamaya yeni bir güncelleme göndermeden (App Store / Play Store onayı beklemeden)
/// uzaktan dinamik parametreleri, kampanya duyurularını, tema renklerini
/// veya özellik açma/kapatma (feature flags) ayarlarını yönetmek için kullanılır.
class RemoteConfigServisi {
  // Firebase Remote Config tekil örneği (Singleton instance)
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Servisi Başlatma ve Uzak Değerleri Çekme Metodu
  ///
  /// Remote Config ağ ve önbellek ayarlarını yapılandırır,
  /// varsayılan (fallback) değerleri tanımlar ve sunucudaki güncel değerleri çeker.
  Future<void> baslat() async {
    // 1. Ağ ve Çekme (Fetch) Ayarlarının Yapılandırılması
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        // Sunucudan veri çekerken beklenecek maksimum süre (zaman aşımı)
        fetchTimeout: const Duration(seconds: 10),

        // İki çekme isteği arasındaki minimum bekleme süresi (önbellek süresi).
        // Test ve geliştirme aşamasında değişiklikleri hemen görebilmek için kısa tutulur (örn: 10 saniye veya Duration.zero).
        // Canlı uygulamalarda (production) sunucu kotasını korumak için genellikle 1-12 saat arası verilir.
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );

    // 2. Yerel Varsayılan Değerler (Defaults)
    // Cihaz internetsiz açıldığında veya sunucudan henüz veri çekilemediğinde
    // uygulamanın çökmesini ya da boş kalmasını önlemek için bu varsayılan değerler kullanılır.
    await _remoteConfig.setDefaults(const {
      'kampanya_aktif': true,
      'kampanya_metni': 'Yeni Kampanya',
      'kampanya_indirim_orani': 30,
      'zorunlu_guncelleme': false,
      'en_dusuk_surum': '1.0.0',
    });

    // 3. Değerleri Sunucudan Çek ve Aktif Hale Getir (Fetch and Activate)
    // İnternet kesintisi veya zaman aşımı durumunda uygulamanın kilitlenmemesi için try-catch içine alınmıştır.
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Hata durumunda uygulama, yukarıda tanımlanan yerel varsayılan değerlerle (setDefaults) çalışmaya devam eder.
    }
  }

  /// Kampanyanın aktif olup olmadığını döndüren getter (boolean)
  ///
  /// Örneğin bir indirim banner'ı gösterilip gösterilmeyeceğini kontrol etmek için kullanılır.
  bool get kampanyaAktifMi => _remoteConfig.getBool('kampanya_aktif');

  /// Uzaktan gelen kampanya başlığı veya duyuru metnini döndüren getter (String)
  ///
  /// Kullanıcı arayüzündeki duyuru kutusunda dinamik metin göstermek için kullanılır.
  String get kampanyaMetni => _remoteConfig.getString('kampanya_metni');

  /// Uygulanacak indirim yüzdesini/oranını döndüren getter (int)
  ///
  /// Fiyat hesaplamalarında veya "%30 İndirim" gibi etiketlerde sayısal değer olarak kullanılır.
  int get indirimOrani => _remoteConfig.getInt('kampanya_indirim_orani');

  /// Zorunlu güncelleme gerekip gerekmediğini bildiren getter (boolean)
  ///
  /// True ise kullanıcıya uygulamayı kapatıp markete gitmesini zorunlu kılan bir diyalog penceresi açılır.
  bool get zorunluGuncelleme => _remoteConfig.getBool('zorunlu_guncelleme');

  /// Uygulamanın sorunsuz çalışabileceği minimum sürüm bilgisini döndüren getter (String)
  ///
  /// Cihazdaki mevcut uygulama sürümü bu değerden eskiyse güncelleme uyarısı tetiklenebilir (örn: '1.0.0').
  String get enDusukSurum => _remoteConfig.getString('en_dusuk_surum');
}
