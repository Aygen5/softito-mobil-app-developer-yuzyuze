import 'package:firebase_analytics/firebase_analytics.dart';

/// [AnalyticsServisi] - Firebase Analytics Servisi
///
/// Uygulama genelinde kullanıcı aksiyonlarını, ekran geçişlerini ve
/// özel olayları (events) Firebase Analytics panosuna göndermek için kullanılır.
class AnalyticsServisi {
  // Firebase Analytics tekil örneği (Singleton instance)
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Ekran Görüntüleme Olayı (Screen View)
  ///
  /// Kullanıcı bir sayfayı açtığında veya ekranlar arası geçiş yaptığında çağrılır.
  /// Firebase konsolunda en çok ziyaret edilen sayfaları ve kullanıcı akışını izlemeyi sağlar.
  ///
  /// [ekranAdi]: Ziyaret edilen sayfanın/ekranın adı (örn: 'AnaSayfa', 'ProfilEkrani').
  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(screenName: ekranAdi);
  }

  /// Genel Özel Olay Gönderme (Custom Event)
  ///
  /// Buton tıklaması, form gönderimi, sepet işlemleri veya hata durumları gibi
  /// uygulamanızdaki her türlü özel davranışı parametreleriyle birlikte kaydeder.
  ///
  /// [olayAdi]: Tetiklenen olayın adı (örn: 'buton_tiklandi', 'urun_sepete_eklendi').
  /// [parametreler]: Olayla birlikte gönderilecek ek anahtar-değer bilgileri (örn: {'kategori': 'elektronik'}).
  Future<void> olayGonder({
    required String olayAdi,
    Map<String, Object>? parametreler,
  }) async {
    await _analytics.logEvent(name: olayAdi, parameters: parametreler);
  }

  /// Kullanıcı Özelliği Belirleme (User Property)
  ///
  /// Kullanıcıları segmentlere ayırmak (örneğin üyelik tipi: 'premium' / 'free',
  /// tercih edilen tema, yaş grubu vb.) amacıyla Firebase Analytics'e özel kullanıcı nitelikleri tanımlar.
  /// Bu özellikler Firebase panelinde hedef kitle (audiences) ve analiz filtreleri oluşturmak için kullanılır.
  ///
  /// [anahtar]: Özelliğin adı (örn: 'uyelik_tipi', 'favori_kategori').
  /// [deger]: Bu özelliğe ait değer (örn: 'gold_uye', 'kitap').
  Future<void> kullaniciOzelligiBelirle({
    required String anahtar,
    required String deger,
  }) async {
    await _analytics.setUserProperty(name: anahtar, value: deger);
  }
}
