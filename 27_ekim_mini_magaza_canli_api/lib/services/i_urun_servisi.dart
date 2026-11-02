import '../models/urun.dart';

// IUrunServisi (Arayüz / Interface):
// Servis katmanının şablonudur. Ekran katmanının (UI) doğrudan API istek kodlarına
// bağımlı olmasını önler (Dependency Inversion).
// İleride Mock servis veya SQLite servisi yazarsak bu arayüzü uygulayarak kolayca değiştirebiliriz.
abstract class IUrunServisi {
  // Sunucudan tüm ürün listesini asenkron (Future) olarak getirme sözleşmesi
  Future<List<Urun>> urunleriGetir();

  // Verilen ID'ye göre tek bir ürün getirme sözleşmesi (bulunamazsa null dönebilir)
  Future<Urun?> urunGetirById(int id);
}

