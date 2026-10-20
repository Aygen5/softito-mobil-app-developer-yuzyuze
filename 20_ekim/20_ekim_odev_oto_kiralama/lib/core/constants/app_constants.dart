class AppConstants {
  AppConstants._();

  static const String appName = 'RotaRent';
  static const String appTagline = 'Güvenilir ve Kolay Araç Kiralama';
  static const String currencySymbol = '₺';

  // Günlük kullanım hakkı (Bilgilendirme)
  static const int dailyKmAllowance = 250;

  // Uzun süreli kiralama indirimi kuralı: 7 gün ve üzeri kiralamalarda %15 indirim
  static const int longTermDiscountDays = 7;
  static const double longTermDiscountRate = 0.15; // %15

  // Araç Kategorileri (project.md gereksinimi)
  static const List<String> categories = [
    'Tümü',
    'Basic',
    'Basic+',
    'Flex',
    'Flex+',
    'Lux',
    'Ultra Lux',
  ];

  // Filtreleme için sadece gerçek kategoriler (Tümü hariç)
  static const List<String> vehicleCategories = [
    'Basic',
    'Basic+',
    'Flex',
    'Flex+',
    'Lux',
    'Ultra Lux',
  ];

  // Vites Türleri
  static const List<String> transmissionTypes = [
    'Tümü',
    'Otomatik',
    'Manuel',
  ];

  // Yakıt Türleri
  static const List<String> fuelTypes = [
    'Tümü',
    'Benzin',
    'Dizel',
    'Hibrit',
    'Elektrik',
  ];

  // Örnek Alış ve Dönüş Noktaları
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

  // Temsili Yakıt Fiyatları (Bilgilendirme amaçlı demo veri)
  static const Map<String, double> sampleFuelPrices = {
    'Kurşunsuz Benzin 95': 44.65,
    'V/Max Diesel (Motorin)': 43.90,
    'Otogaz (LPG)': 22.45,
    'Elektrik Şarj (AC)': 8.50,
    'Elektrik Hızlı Şarj (DC)': 12.00,
  };

  // Rezervasyon Durumları
  static const String statusConfirmed = 'Onaylandı';
  static const String statusPending = 'Bekliyor';
  static const String statusCompleted = 'Tamamlandı';
  static const String statusCancelled = 'İptal Edildi';

  // Demo Kullanıcı Bilgisi
  static const String demoUserName = 'Aygen Yıldırım';
  static const String demoUserEmail = 'aygen.yildirim@rotarent.com.tr';
  static const String demoUserPhone = '+90 (555) 012 34 56';
  static const String demoUserRole = 'Gold Üye';
}
