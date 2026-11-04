/// ============================================================================
/// BİLDİRİM VERİ MODELİ (NOTIFICATION DATA MODEL)
/// ============================================================================
/// Uygulama içerisinde Firebase Cloud Messaging (FCM) üzerinden gelen veya
/// yerel olarak oluşturulan bildirimlerin verilerini tip güvenli (type-safe)
/// bir şekilde taşımak ve arayüzde (UI) listelemek için kullanılan model sınıfıdır.
/// 
/// 💡 İmmutability (Değişmezlik):
/// Sınıftaki tüm alanlar `final` olarak tanımlanmıştır. Bu sayede nesne bir kez
/// oluşturulduktan sonra kazara durumu bozulamaz; Flutter ve state management
/// yapılarında (Provider, Bloc, ValueNotifier) güvenle kullanılabilir.
class BildirimModeli {
  // Bildirimin benzersiz kimliği (FCM messageId veya yerel üretilen UUID)
  final String? id;

  // Bildirimin başlık metni (Örn: 'Yeni Ders Materyali')
  final String? baslik;

  // Bildirimin gövde/içerik metni (Örn: 'Firebase ders notları sisteme yüklendi.')
  final String? icerik;

  // Bildirimin cihaza ulaştığı anın zaman damgası
  final DateTime tarih;

  // Kullanıcının bildirimi okuyup okumadığını belirten durum bayrağı
  final bool okunduMu;

  /// Değişmez (immutable) yapıcı metot (Constructor)
  const BildirimModeli({
    required this.id,
    required this.baslik,
    required this.icerik,
    required this.tarih,
    required this.okunduMu,
  });

  /// ==========================================================================
  /// COPYWITH DESENİ (COPYWITH PATTERN)
  /// ==========================================================================
  /// İmmutable sınıflarda bir nesnenin sadece bir veya birkaç alanını (örneğin
  /// `okunduMu = true`) güncellemek gerektiğinde, var olan nesneyi mutasyona uğratmak
  /// yerine mevcut değerleri koruyarak yeni bir kopya üretilmesini sağlar.
  /// 
  /// 📌 Dart İsimlendirme Kuralı Notu:
  /// Dart standardında metot isimleri küçük harfle (camelCase) başlar (`copyWith`).
  /// Kodda `CopyWith` olarak yazılmış olup geriye güncellenmiş nesneyi döndürür.
  BildirimModeli CopyWith({
    String? id,
    String? baslik,
    String? icerik,
    DateTime? tarih,
    bool? okunduMu,
  }) {
    return BildirimModeli(
      id: id ?? this.id,                     // Yeni değer verilmişse onu al, yoksa eskisini koru
      baslik: baslik ?? this.baslik,
      icerik: icerik ?? this.icerik,
      tarih: tarih ?? this.tarih,
      okunduMu: okunduMu ?? this.okunduMu,
    );
  }
}
