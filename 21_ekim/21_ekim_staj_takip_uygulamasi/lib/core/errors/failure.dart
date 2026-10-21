import 'package:equatable/equatable.dart';

/// Cubit durumlarında kullanılan hata nesnesi.
class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  /// Firebase Authentication hata kodlarını anlaşılır Türkçe mesajlara çevirir.
  factory Failure.fromAuthCode(String code) {
    switch (code) {
      case 'user-not-found':
        return Failure(
          'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.',
          code: code,
        );
      case 'wrong-password':
      case 'invalid-credential':
        return Failure('E-posta veya şifre hatalı.', code: code);
      case 'email-already-in-use':
        return Failure(
          'Bu e-posta adresi zaten başka bir hesap tarafından kullanılıyor.',
          code: code,
        );
      case 'invalid-email':
        return Failure('Geçerli bir e-posta adresi giriniz.', code: code);
      case 'weak-password':
        return Failure(
          'Şifreniz çok zayıf. Lütfen en az 6 karakterli güçlü bir şifre seçiniz.',
          code: code,
        );
      case 'user-disabled':
        return Failure(
          'Bu kullanıcı hesabı yönetici tarafından askıya alınmıştır.',
          code: code,
        );
      case 'too-many-requests':
        return Failure(
          'Çok fazla başarısız deneme yaptınız. Lütfen bir süre sonra tekrar deneyiniz.',
          code: code,
        );
      case 'network-request-failed':
        return Failure(
          'Ağ bağlantısı kurulamadı. İnternetinizi kontrol ediniz.',
          code: code,
        );
      default:
        return Failure(
          'Kimlik doğrulama sırasında bir hata oluştu: $code',
          code: code,
        );
    }
  }

  /// Cloud Firestore hata kodlarını anlaşılır Türkçe mesajlara çevirir.
  factory Failure.fromFirestoreCode(String code) {
    switch (code) {
      case 'permission-denied':
        return Failure(
          'Bu veriye erişim veya değişiklik yetkiniz bulunmamaktadır.',
          code: code,
        );
      case 'not-found':
        return Failure(
          'Aranan kayıt Firestore üzerinde bulunamadı.',
          code: code,
        );
      case 'unavailable':
        return Failure(
          'Sunucuya geçici olarak ulaşılamıyor. Lütfen tekrar deneyiniz.',
          code: code,
        );
      case 'already-exists':
        return Failure('Bu kayıt zaten mevcut.', code: code);
      default:
        return Failure(
          'Veritabanı işlemi sırasında bir hata oluştu: $code',
          code: code,
        );
    }
  }

  /// Firebase Storage hata kodlarını anlaşılır Türkçe mesajlara çevirir.
  factory Failure.fromStorageCode(String code) {
    switch (code) {
      case 'unauthorized':
        return Failure('Dosyayı yükleme veya erişim yetkiniz yok.', code: code);
      case 'canceled':
        return Failure('Dosya yükleme işlemi iptal edildi.', code: code);
      case 'object-not-found':
        return Failure(
          'İstenen dosya depolama alanında bulunamadı.',
          code: code,
        );
      case 'quota-exceeded':
        return Failure('Depolama kotası aşıldı.', code: code);
      default:
        return Failure(
          'Dosya işlemi sırasında bir hata oluştu: $code',
          code: code,
        );
    }
  }
}
