import 'package:firebase_remote_config/firebase_remote_config.dart';

/// [RemoteConfigServisi] - Firebase Remote Config Servisi
///
/// Uygulama mağazaya yeni bir güncelleme göndermeden, uzaktan dinamik olarak
/// kampanya metinlerini, özellik açma/kapama (feature flags) durumlarını
/// ve zorunlu sürüm bilgilerini yönetmek için kullanılan servis sınıfıdır.
class RemoteConfigServisi {
  // FirebaseRemoteConfig tekil örneği (Singleton instance)
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  /// Servisi Başlatma ve Uzak Değerleri Çekme Metodu
  ///
  /// Remote Config ayarlarını yapılandırır, internet erişimi olmadığı durumlar
  /// için varsayılan (fallback) değerleri tanımlar ve sunucudaki güncel değerleri çeker.
  Future<void> baslat() async {
    // 1. Çekme ayarları (Fetch Settings)
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10), // Sunucudan yanıt bekleme üst sınırı
        minimumFetchInterval: Duration.zero,       // Geliştirme/test aşamasında anında güncelleme almak için 0 yapıldı (Canlıda genellikle 1-12 saat arası verilir)
      ),
    );

    // 2. Varsayılan Değerler (Defaults)
    // Cihaz henüz internete bağlanmadıysa veya sunucuda henüz bu anahtar tanımlanmadıysa bu değerler geçerlidir.
    await _rc.setDefaults(const {
      'kampanya_aktif': false,
      'kampanya_metni': 'Yeni bir indirim kampanyası başladı!',
      'zorunlu_surum': '1.0.1',
    });

    // 3. Değerleri Çek ve Aktifleştir (Fetch and Activate)
    // Firebase sunucusundaki değerleri çeker ve uygulama içinde kullanıma sunar.
    await _rc.fetchAndActivate();
  }

  /// Kampanyanın aktif olup olmadığını döndüren getter (boolean)
  bool get kampanyaAktifMi => _rc.getBool('kampanya_aktif');

  /// Uzaktan gelen kampanya duyuru metnini döndüren getter (string)
  String get kampanyaMetni => _rc.getString('kampanya_metni');

  /// Uygulamanın çalışması için gereken minimum zorunlu sürümü döndüren getter (string)
  String get zorunluSurum => _rc.getString('zorunlu_surum');
}
