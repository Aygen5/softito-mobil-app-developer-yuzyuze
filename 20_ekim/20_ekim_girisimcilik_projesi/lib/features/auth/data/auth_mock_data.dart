import '../models/user_model.dart';
import '../models/user_role.dart';

/// Kimlik doğrulama modülü için sabit demo hesap bilgileri ve örnek kullanıcı üreteçleri.
/// Bu sınıftaki bilgiler güvenli kimlik doğrulama bilgisi DEĞİLDİR;
/// uygulamanın yerel demo akışını ve rollerini deneyimlemek için sunulmuştur.
abstract final class AuthMockData {
  /// Standart demo şifresi
  static const String demoSifre = 'yorunge123';

  // --- 1. GİRİŞİMCİ (ONAYLI) ---
  static const String demoEmailGirisimci = 'girisimci@yorunge.demo';
  static UserModel get girisimciOnayli => UserModel(
        id: 'usr_girisimci_001',
        adSoyad: 'Deniz Yörünge',
        email: demoEmailGirisimci,
        rol: UserRole.entrepreneur,
        isApproved: true,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 1, 1),
      );

  // --- 2. GİRİŞİMCİ (ONAYSIZ / ADAY) ---
  static const String demoEmailAdayGirisimci = 'aday.girisimci@yorunge.demo';
  static UserModel get girisimciOnaysiz => UserModel(
        id: 'usr_aday_002',
        adSoyad: 'Barış Yeni',
        email: demoEmailAdayGirisimci,
        rol: UserRole.entrepreneur,
        isApproved: false,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 2, 1),
      );

  // --- 3. YATIRIMCI ---
  static const String demoEmailYatirimci = 'yatirimci@yorunge.demo';
  static UserModel get yatirimci => UserModel(
        id: 'usr_yatirimci_003',
        adSoyad: 'Leyla Fon (Melek Yatırımcı)',
        email: demoEmailYatirimci,
        rol: UserRole.investor,
        isApproved: true,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 1, 15),
      );

  // --- 4. MENTOR ---
  static const String demoEmailMentor = 'mentor@yorunge.demo';
  static UserModel get mentor => UserModel(
        id: 'usr_mentor_004',
        adSoyad: 'Dr. Kerem Danışman',
        email: demoEmailMentor,
        rol: UserRole.mentor,
        isApproved: true,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 1, 10),
      );

  // --- 5. KURUM TEMSİLCİSİ (PROGRAM SAĞLAYICI) ---
  static const String demoEmailKurum = 'kurum@yorunge.demo';
  static UserModel get kurumTemsilcisi => UserModel(
        id: 'usr_kurum_005',
        adSoyad: 'Selin Destek (TÜBİTAK Temsilcisi)',
        email: demoEmailKurum,
        rol: UserRole.programProvider,
        isApproved: true,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 1, 5),
      );

  // --- 6. PLATFORM YÖNETİCİSİ (ADMİN) ---
  static const String demoEmailAdmin = 'admin@yorunge.demo';
  static UserModel get admin => UserModel(
        id: 'usr_admin_006',
        adSoyad: 'Yönetici Atlas',
        email: demoEmailAdmin,
        rol: UserRole.admin,
        isApproved: true,
        isDemo: true,
        olusturulmaTarihi: DateTime(2026, 1, 1),
      );

  /// Geriye dönük uyumluluk için varsayılan kullanıcı
  static const String demoEmail = demoEmailGirisimci;
  static const String demoAdSoyad = 'Deniz Yörünge';
  static UserModel get varsayilanDemoKullanici => girisimciOnayli;

  /// Kolay test için tüm demo hesapları listesi
  static List<UserModel> get tumDemoHesaplar => [
        girisimciOnayli,
        girisimciOnaysiz,
        yatirimci,
        mentor,
        kurumTemsilcisi,
        admin,
      ];

  /// E-postaya göre demo hesabı eşleştirme
  static UserModel? findDemoUserByEmail(String email) {
    final clean = email.toLowerCase().trim();
    if (clean == 'demo@yorunge.app' || clean == demoEmailGirisimci) {
      return girisimciOnayli;
    }
    if (clean == demoEmailAdayGirisimci) {
      return girisimciOnaysiz;
    }
    if (clean == demoEmailYatirimci) {
      return yatirimci;
    }
    if (clean == demoEmailMentor) {
      return mentor;
    }
    if (clean == demoEmailKurum) {
      return kurumTemsilcisi;
    }
    if (clean == demoEmailAdmin) {
      return admin;
    }
    return null;
  }

  /// "Hızlı Demo Hesabı" tıklandığında dinamik olarak oluşturulan kullanıcı
  static UserModel hizliDemoKullaniciOlustur({
    UserRole role = UserRole.entrepreneur,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return UserModel(
      id: 'usr_hizli_$timestamp',
      adSoyad: 'Demo Kurucu ($timestamp)',
      email: 'kurucu_$timestamp@yorunge.demo',
      rol: role,
      isApproved: true,
      isDemo: true,
      olusturulmaTarihi: DateTime.now(),
    );
  }
}
