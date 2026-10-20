import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_mock_data.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

/// Kimlik doğrulama, çoklu rol desteği ve demo kullanıcı oturumunu yöneten controller.
/// UI sınıflarına bağımlılığı (BuildContext, Widget) yoktur.
class AuthController {
  static const String _prefIsLoggedIn = 'yorunge_auth_is_logged_in';
  static const String _prefUserId = 'yorunge_auth_user_id';
  static const String _prefUserAdSoyad = 'yorunge_auth_user_ad_soyad';
  static const String _prefUserEmail = 'yorunge_auth_user_email';
  static const String _prefUserRol = 'yorunge_auth_user_rol';
  static const String _prefUserIsApproved = 'yorunge_auth_user_is_approved';

  final ValueNotifier<UserModel?> currentUser;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<String?> errorMessage;

  AuthController({UserModel? initialUser})
      : currentUser = ValueNotifier<UserModel?>(initialUser),
        isLoading = ValueNotifier<bool>(false),
        errorMessage = ValueNotifier<String?>(null);

  /// Oturum açık mı?
  bool get isAuthenticated => currentUser.value != null;

  /// Aktif kullanıcının rolü
  UserRole? get currentRole => currentUser.value?.rol;

  /// Aktif kullanıcının onay durumu (Örn: Girişimci topluluk yetkisi için)
  bool get isApproved => currentUser.value?.isApproved ?? false;

  /// SharedPreferences üzerinden var olan yerel oturumu başlatır ve yükler.
  /// Şifreler asla diske yazılmaz veya okunmaz.
  Future<void> initSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_prefIsLoggedIn) ?? false;

      if (isLoggedIn) {
        final id = prefs.getString(_prefUserId) ?? 'usr_demo_001';
        final adSoyad =
            prefs.getString(_prefUserAdSoyad) ?? AuthMockData.demoAdSoyad;
        final email = prefs.getString(_prefUserEmail) ?? AuthMockData.demoEmail;
        final rolString = prefs.getString(_prefUserRol);
        final isApproved = prefs.getBool(_prefUserIsApproved) ?? true;

        currentUser.value = UserModel(
          id: id,
          adSoyad: adSoyad,
          email: email,
          rol: UserRole.fromString(rolString),
          isApproved: isApproved,
          isDemo: true,
          olusturulmaTarihi: DateTime.now(),
        );
      }
    } catch (_) {
      // Hata durumunda oturumsuz devam et
    }
  }

  /// Sabit demo hesaplarıyla oturum açma işlemi.
  /// Tanımlı beş rolden herhangi birinin e-posta bilgisiyle giriş yapılabilir.
  Future<bool> login({
    required String email,
    required String sifre,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    final trimmedEmail = email.trim();
    final trimmedSifre = sifre.trim();

    if (trimmedEmail.isEmpty) {
      errorMessage.value = 'Lütfen e-posta adresinizi giriniz.';
      isLoading.value = false;
      return false;
    }

    if (trimmedSifre.isEmpty) {
      errorMessage.value = 'Lütfen şifrenizi giriniz.';
      isLoading.value = false;
      return false;
    }

    // Demo hesap eşleme kontrolü
    final matchedUser = AuthMockData.findDemoUserByEmail(trimmedEmail);
    final isPasswordMatch = trimmedSifre == AuthMockData.demoSifre;

    if (matchedUser != null && isPasswordMatch) {
      currentUser.value = matchedUser;
      await _persistSession(matchedUser);
      isLoading.value = false;
      return true;
    } else {
      errorMessage.value =
          'Geçersiz demo e-posta veya şifre.\n(Şifre tüm demo hesapları için: ${AuthMockData.demoSifre})';
      isLoading.value = false;
      return false;
    }
  }

  /// Yeni bir yerel demo hesabı oluşturma ve oturum başlatma.
  Future<bool> register({
    required String adSoyad,
    required String email,
    required String sifre,
    required String sifreTekrari,
    UserRole rol = UserRole.entrepreneur,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    final trimmedName = adSoyad.trim();
    final trimmedEmail = email.trim();
    final trimmedSifre = sifre.trim();
    final trimmedSifreTekrari = sifreTekrari.trim();

    if (trimmedName.isEmpty) {
      errorMessage.value = 'Lütfen adınızı ve soyadınızı giriniz.';
      isLoading.value = false;
      return false;
    }

    if (trimmedEmail.isEmpty) {
      errorMessage.value = 'Lütfen e-posta adresinizi giriniz.';
      isLoading.value = false;
      return false;
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      errorMessage.value =
          'Geçerli bir e-posta formatı giriniz (örn: kurucu@girisim.io).';
      isLoading.value = false;
      return false;
    }

    if (trimmedSifre.length < 6) {
      errorMessage.value = 'Şifreniz en az 6 karakterden oluşmalıdır.';
      isLoading.value = false;
      return false;
    }

    if (trimmedSifre != trimmedSifreTekrari) {
      errorMessage.value = 'Girdiğiniz şifreler birbiriyle eşleşmiyor.';
      isLoading.value = false;
      return false;
    }

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      adSoyad: trimmedName,
      email: trimmedEmail,
      rol: rol,
      isApproved:
          rol != UserRole.entrepreneur, // Yeni girişimci başlangıçta onaysızdır
      isDemo: true,
      olusturulmaTarihi: DateTime.now(),
    );

    currentUser.value = newUser;
    await _persistSession(newUser);
    isLoading.value = false;
    return true;
  }

  /// Form doldurmadan tek tıkla hızlı demo oturumu açma
  Future<bool> loginAsQuickDemo({
    UserRole role = UserRole.entrepreneur,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    final user = AuthMockData.hizliDemoKullaniciOlustur(role: role);
    currentUser.value = user;
    await _persistSession(user);

    isLoading.value = false;
    return true;
  }

  /// Demo geliştirme sürecinde hesaplar arasında doğrudan hızlı geçiş yapma
  Future<void> switchDemoAccount(UserModel user) async {
    isLoading.value = true;
    currentUser.value = user;
    await _persistSession(user);
    isLoading.value = false;
  }

  /// Oturumu kapatır ve SharedPreferences belleğini temizler
  Future<void> logout() async {
    currentUser.value = null;
    errorMessage.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefIsLoggedIn);
      await prefs.remove(_prefUserId);
      await prefs.remove(_prefUserAdSoyad);
      await prefs.remove(_prefUserEmail);
      await prefs.remove(_prefUserRol);
      await prefs.remove(_prefUserIsApproved);
    } catch (_) {}
  }

  /// Hata mesajını sıfırlar
  void clearError() {
    errorMessage.value = null;
  }

  Future<void> _persistSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefIsLoggedIn, true);
      await prefs.setString(_prefUserId, user.id);
      await prefs.setString(_prefUserAdSoyad, user.adSoyad);
      await prefs.setString(_prefUserEmail, user.email);
      await prefs.setString(_prefUserRol, user.rol.name);
      await prefs.setBool(_prefUserIsApproved, user.isApproved);
    } catch (_) {}
  }

  void dispose() {
    currentUser.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
