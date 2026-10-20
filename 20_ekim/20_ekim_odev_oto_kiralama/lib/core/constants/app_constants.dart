/// ---------------------------------------------------------------------------
/// 📌 AppConstants — Uygulama Genelinde Kullanılan Sabit Değerler
/// ---------------------------------------------------------------------------
/// Neden sabitler için ayrı bir sınıf oluştururuz?
/// 1. 'Magic Numbers' ve 'Magic Strings' (kodun içine serpiştirilmiş kontrolsüz metinler)
///    yerine tek bir merkezi noktadan yönetimi sağlar.
/// 2. Yarın indirim oranı %15'ten %20'ye çıkarsa tek bir satırı değiştirmemiz yeterlidir.
/// 3. Yazım hatalarını (typo) derleme aşamasında yakalamamızı sağlar.
class AppConstants {
  /// 'Private Constructor' (Gizli Yapıcı Metot):
  /// Sınıf adının sonuna '._()' koyarak dışarıdan `AppConstants()` şeklinde
  /// bir nesne üretilmesini (instantiation) engelleriz.
  /// Çünkü bu sınıf sadece statik sabitleri barındıran bir 'utility/namespace' sınıfıdır.
  AppConstants._();

  // Uygulama Adı ve Kurumsal Slogan
  static const String appName = 'RotaRent';
  static const String appTagline = 'Güvenilir ve Kolay Araç Kiralama';
  static const String currencySymbol = '₺';

  // ---------------------------------------------------------------------------
  // 💼 İş Kuralları (Business Rules)
  // ---------------------------------------------------------------------------
  /// Günlük kullanım hakkı kuralı: Sözleşme gereği araçlar günlük maksimum 250 km kullanılabilir.
  static const int dailyKmAllowance = 250;

  /// Uzun süreli kiralama indirim kuralı:
  /// Kullanıcı 7 gün veya daha uzun süreli kiralama yaptığında toplam fiyata
  /// otomatik %15 indirim uygulanır.
  static const int longTermDiscountDays = 7;
  static const double longTermDiscountRate = 0.15; // %15

  // ---------------------------------------------------------------------------
  // 🚗 Araç Kategorileri ve Filtreleme Seçenekleri
  // ---------------------------------------------------------------------------
  /// UI'da filtreleme çiplerinde (tab/chip) 'Tümü' seçeneğini de göstermek için liste
  static const List<String> categories = [
    'Tümü',
    'Basic',
    'Basic+',
    'Flex',
    'Flex+',
    'Lux',
    'Ultra Lux',
  ];

  /// Sadece araçların kendi modellerine atanabilen gerçek kategori isimleri
  static const List<String> vehicleCategories = [
    'Basic',
    'Basic+',
    'Flex',
    'Flex+',
    'Lux',
    'Ultra Lux',
  ];

  /// Vites türü filtreleme seçenekleri
  static const List<String> transmissionTypes = [
    'Tümü',
    'Otomatik',
    'Manuel',
  ];

  /// Yakıt türü filtreleme seçenekleri
  static const List<String> fuelTypes = [
    'Tümü',
    'Benzin',
    'Dizel',
    'Hibrit',
    'Elektrik',
  ];

  // ---------------------------------------------------------------------------
  // 📍 Lokasyon ve İstasyon Bilgileri
  // ---------------------------------------------------------------------------
  /// Örnek Alış ve Dönüş Noktaları (Dropdown menülerde kullanıcıya sunulur)
  static const List<String> pickupLocations = [
    'İstanbul - Havalimanı (IST)',
    'İstanbul - Sabiha Gökçen Havalimanı (SAW)',
    'İstanbul - Kadıköy Rıhtım Şube',
    'İstanbul - Levent Kanyon Şube',
    'İstanbul - Beşiktaş Çarşı Şube',
    'Ankara - Esenboğa Havalimanı (ESB)',
    'Ankara - Çankaya Tunalı Şube',
    'İzmir - Adnan Menderes Havalimanı (ADB)',
    'İzmir - Alsancak Marina Şube',
    'Antalya - Havalimanı (AYT)',
  ];

  // ---------------------------------------------------------------------------
  // ⛽ Akaryakıt Fiyat Bilgilendirmesi (Demo Veri)
  // ---------------------------------------------------------------------------
  /// Araç detay ekranında yakıt göstergesine tıklandığında açılan modal için
  /// ortalama güncel pompa fiyatları (TL/Litre veya TL/kWh).
  static const Map<String, double> sampleFuelPrices = {
    'Kurşunsuz Benzin 95': 44.65,
    'V/Max Diesel (Motorin)': 43.90,
    'Otogaz (LPG)': 22.45,
    'Elektrik Şarj (AC)': 8.50,
    'Elektrik Hızlı Şarj (DC)': 12.00,
  };

  // ---------------------------------------------------------------------------
  // 📋 Rezervasyon Durumları (Status)
  // ---------------------------------------------------------------------------
  static const String statusConfirmed = 'Onaylandı';
  static const String statusPending = 'Bekliyor';
  static const String statusCompleted = 'Tamamlandı';
  static const String statusCancelled = 'İptal Edildi';

  // ---------------------------------------------------------------------------
  // 👤 Demo Kullanıcı Bilgisi (Kimlik Doğrulama Servisi Olmadığı İçin)
  // ---------------------------------------------------------------------------
  static const String demoUserName = 'Aygen Yıldırım';
  static const String demoUserEmail = 'aygen.yildirim@rotarent.com.tr';
  static const String demoUserPhone = '+90 (555) 012 34 56';
  static const String demoUserRole = 'Gold Üye';
}

