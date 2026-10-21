/// StajTakip genel uygulama hata sınıfı hiyerarşisi.
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Kimlik doğrulama ve oturum hataları
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

/// Ağ ve bağlantı hataları
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'İnternet bağlantınızı kontrol ediniz.',
  ]) : super(code: 'network-error');
}

/// Yetkisiz işlem hataları
class PermissionException extends AppException {
  const PermissionException([
    super.message = 'Bu işlemi yapmaya yetkiniz bulunmamaktadır.',
  ]) : super(code: 'permission-denied');
}

/// Kayıt bulunamadı hataları
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'İstenen kayıt bulunamadı.'])
    : super(code: 'not-found');
}

/// Doğrulama ve form hataları
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// Dosya yükleme ve depolama hataları
class StorageException extends AppException {
  const StorageException([
    super.message = 'Dosya işlemi sırasında bir hata oluştu.',
  ]) : super(code: 'storage-error');
}

/// PDF üretim hataları
class PdfException extends AppException {
  const PdfException([
    super.message = 'PDF belgesi oluşturulurken bir hata oluştu.',
  ]) : super(code: 'pdf-error');
}
