// Kategori Enumu:
// API'den gelen string kategori isimlerini ("electronics", "jewelery") doğrudan string olarak kullanmak yerine
// enum'a çevirdik. Amacı: Tip güvenliği (type-safety) sağlamak ve kod yazarken harf hatası yapmayı önlemek.
enum Kategori {
  hepsi,        // Filtrelemede 'Tümü' seçeneği için
  elektronik,   // FakeStore: electronics
  taki,         // FakeStore: jewelery
  erkekGiyim,   // FakeStore: men's clothing
  kadinGiyim,   // FakeStore: women's clothing
}

// KategoriExtension:
// Kategori enum'ına ek özellikler kazandırmak için extension kullandık.
extension KategoriExtension on Kategori {
  // gorunenAd: Arayüzdeki filtre butonlarında (FilterChip) kullanıcıya gösterilecek Türkçe isimler
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return 'Tümü';
      case Kategori.elektronik:
        return 'Elektronik';
      case Kategori.taki:
        return 'Takı & Mücevher';
      case Kategori.erkekGiyim:
        return 'Erkek Giyim';
      case Kategori.kadinGiyim:
        return 'Kadın Giyim';
    }
  }

  // apiMetnindenUret: FakeStore API'den gelen İngilizce kategori metnini enum değerine dönüştürür
  static Kategori apiMetnindenUret(String apiMetni) {
    switch (apiMetni.toLowerCase().trim()) {
      case 'electronics':
        return Kategori.elektronik;
      case 'jewelery':
        return Kategori.taki;
      case "men's clothing":
        return Kategori.erkekGiyim;
      case "women's clothing":
        return Kategori.kadinGiyim;
      default:
        return Kategori.elektronik; // Beklenmedik bir kategori gelirse patlamasın diye varsayılan atadık
    }
  }
}

