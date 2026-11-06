import 'package:firebase_analytics/firebase_analytics.dart';

/// [AnalitikServisi] - Firebase Analytics Servisi
///
/// Kullanıcıların uygulama içi davranışlarını, ziyaret ettikleri sayfaları
/// ve gerçekleştirdikleri aksiyonları (örneğin buton tıklamaları, sepete ürün ekleme)
/// takip edip Firebase Analytics panosuna raporlamak için kullanılır.
class AnalitikServisi {
  // FirebaseAnalytics tekil örneği (Singleton instance)
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Ekran Görüntüleme Olayı (Screen View)
  ///
  /// Kullanıcının hangi ekranı açtığını kaydeder.
  /// Firebase konsolunda en çok ziyaret edilen sayfaları görmeyi sağlar.
  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(
      screenName: ekranAdi,
    );
  }

  /// Özel Buton Tıklama Olayı (Custom Event)
  ///
  /// Kullanıcı bir butona bastığında, butonun ID'si, kategorisi
  /// ve tıklanma zaman damgasıyla birlikte özel bir analitik olayı kaydeder.
  Future<void> butonTiklandi({
    required String butonId,
    required String kategori,
  }) async {
    await _analytics.logEvent(
      name: "buton_tiklama",
      parameters: {
        "buton_id": butonId,
        "kategori": kategori,
        "zaman": DateTime.now().toIso8601String(), // ISO formatında anlık tarih/saat
      },
    );
  }

  /// E-Ticaret Sepete Ekleme Olayı
  ///
  /// Kullanıcı bir ürünü sepete eklediğinde ürün ID'si, fiyatı
  /// ve para birimi bilgilerini içeren bir etkinlik (event) kaydeder.
  Future<void> urunSepeteEklendi({
    required String urunId,
    required double fiyat,
  }) async {
    await _analytics.logEvent(
      name: 'sepete_ekle',
      parameters: {
        'urun_id': urunId,
        'fiyat': fiyat,
        'para_birimi': 'TL',
      },
    );
  }
}
