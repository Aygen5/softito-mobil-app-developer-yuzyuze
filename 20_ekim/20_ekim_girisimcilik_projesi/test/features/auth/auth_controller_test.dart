import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge/features/auth/controller/auth_controller.dart';
import 'package:yorunge/features/auth/data/auth_mock_data.dart';

void main() {
  group('AuthController Tests', () {
    late AuthController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = AuthController();
    });

    tearDown(() {
      controller.dispose();
    });

    test(
        '1. Başlangıçta aktif oturum yoktur (currentUser null, isAuthenticated false)',
        () {
      expect(controller.currentUser.value, isNull);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('2. Geçerli sabit demo hesabıyla giriş başarılıdır ve oturum açılır',
        () async {
      final success = await controller.login(
        email: AuthMockData.demoEmail,
        sifre: AuthMockData.demoSifre,
      );

      expect(success, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(
          controller.currentUser.value?.email, equals(AuthMockData.demoEmail));
      expect(controller.currentUser.value?.adSoyad,
          equals(AuthMockData.demoAdSoyad));
      expect(controller.errorMessage.value, isNull);
    });

    test(
        '3. Hatalı demo bilgileriyle giriş başarısızdır ve hata mesajı gösterilir',
        () async {
      final success = await controller.login(
        email: 'hatali@domain.com',
        sifre: 'yanlissifre',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser.value, isNull);
      expect(controller.errorMessage.value, isNotNull);
      expect(controller.errorMessage.value, contains('Geçersiz demo'));
    });

    test('4. Boş e-posta veya şifre ile giriş engellenir', () async {
      final emptyEmail = await controller.login(email: '', sifre: '123456');
      expect(emptyEmail, isFalse);
      expect(controller.errorMessage.value, contains('e-posta'));

      final emptyPassword = await controller.login(
        email: 'test@yorunge.app',
        sifre: '',
      );
      expect(emptyPassword, isFalse);
      expect(controller.errorMessage.value, contains('şifre'));
    });

    test(
        '5. Form doğrulamasını geçemeyen kayıt işlemi oturum açmaz (boş ad soyad)',
        () async {
      final success = await controller.register(
        adSoyad: '  ',
        email: 'kurucu@girisim.io',
        sifre: '123456',
        sifreTekrari: '123456',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage.value, contains('adınızı'));
    });

    test(
        '6. Form doğrulamasını geçemeyen kayıt işlemi oturum açmaz (geçersiz e-posta)',
        () async {
      final success = await controller.register(
        adSoyad: 'Ali Veli',
        email: 'gecersiz-eposta-formati',
        sifre: '123456',
        sifreTekrari: '123456',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage.value, contains('formatı'));
    });

    test(
        '7. Form doğrulamasını geçemeyen kayıt işlemi oturum açmaz (kısa şifre)',
        () async {
      final success = await controller.register(
        adSoyad: 'Ayşe Kurucu',
        email: 'ayse@girisim.io',
        sifre: '123',
        sifreTekrari: '123',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage.value, contains('en az 6'));
    });

    test(
        '8. Form doğrulamasını geçemeyen kayıt işlemi oturum açmaz (şifre uyuşmazlığı)',
        () async {
      final success = await controller.register(
        adSoyad: 'Can Kurucu',
        email: 'can@girisim.io',
        sifre: '123456',
        sifreTekrari: '654321',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage.value, contains('eşleşmiyor'));
    });

    test('9. Geçerli kayıt formu yeni demo oturumu başlatır', () async {
      final success = await controller.register(
        adSoyad: 'Elif Yılmaz',
        email: 'elif@startup.com',
        sifre: 'parola123',
        sifreTekrari: 'parola123',
      );

      expect(success, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser.value?.adSoyad, equals('Elif Yılmaz'));
      expect(controller.currentUser.value?.email, equals('elif@startup.com'));
      expect(controller.currentUser.value?.isDemo, isTrue);
    });

    test('10. Hızlı demo hesabı seçeneği doğrudan oturum açar', () async {
      final success = await controller.loginAsQuickDemo();

      expect(success, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser.value, isNotNull);
      expect(controller.currentUser.value?.isDemo, isTrue);
    });

    test(
        '11. Çıkış (logout) sonrası oturum kapatılır ve unauthenticated duruma geçilir',
        () async {
      await controller.login(
        email: AuthMockData.demoEmail,
        sifre: AuthMockData.demoSifre,
      );
      expect(controller.isAuthenticated, isTrue);

      await controller.logout();
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser.value, isNull);
    });

    test(
        '12. Oturum kalıcılığı: initSession() SharedPreferences kayıtlı oturumu geri yükler',
        () async {
      SharedPreferences.setMockInitialValues({
        'yorunge_auth_is_logged_in': true,
        'yorunge_auth_user_id': 'usr_stored_77',
        'yorunge_auth_user_ad_soyad': 'Kalıcı Girişimci',
        'yorunge_auth_user_email': 'kalici@yorunge.app',
        'yorunge_auth_user_rol': 'Kurucu',
      });

      final freshController = AuthController();
      await freshController.initSession();

      expect(freshController.isAuthenticated, isTrue);
      expect(freshController.currentUser.value?.adSoyad,
          equals('Kalıcı Girişimci'));
      expect(freshController.currentUser.value?.email,
          equals('kalici@yorunge.app'));

      freshController.dispose();
    });
  });
}
