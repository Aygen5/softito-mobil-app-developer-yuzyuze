import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

/// Kimlik doğrulama durumlarının temel sınıfı.
sealed class AuthState extends Equatable {
  const AuthState();

  UserModel? get currentUser =>
      this is Authenticated ? (this as Authenticated).user : null;

  @override
  List<Object?> get props => [];
}

/// Uygulama ilk açıldığında durum.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Giriş, kayıt veya profil yükleme işlemi sürerken durum.
final class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Kullanıcı başarıyla oturum açtığında ve Firestore profili doğrulandığında durum.
final class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Geriye dönük uyumluluk takma adı
typedef AuthAuthenticated = Authenticated;

/// Oturum kapalı veya giriş yapılmamış durum.
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Kullanıcının Auth hesabı var ancak Firestore'da profili henüz açılmamış,
/// pasif yapılmış veya yetki onayı bekliyor.
final class AuthPendingApproval extends AuthState {
  final String uid;
  final String email;
  final String message;

  const AuthPendingApproval({
    required this.uid,
    required this.email,
    this.message = 'Hesabınız henüz onaylanmamış veya profiliniz tanımlanmamıştır. Lütfen yöneticinizle iletişime geçiniz.',
  });

  @override
  List<Object?> get props => [uid, email, message];
}

/// Bir işlem başarısız olduğunda durum.
final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Şifre sıfırlama bağlantısı e-postaya gönderildiğinde durum.
final class PasswordResetSent extends AuthState {
  final String email;

  const PasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}
