import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'auth_state.dart';
export 'auth_state.dart';

/// Kimlik doğrulama, kullanıcı profili ve oturum yönetimi Cubit sınıfı.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  StreamSubscription<dynamic>? _authSubscription;

  AuthCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(const AuthInitial()) {
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription = authRepository.authStateChanges.listen((user) async {
      if (user == null) {
        if (!isClosed) emit(const Unauthenticated());
      } else {
        await _loadUserProfile(user.uid, user.email ?? '');
      }
    }, onError: (error) {
      if (!isClosed) {
        emit(AuthError(error is Failure ? error.message : error.toString()));
      }
    });
  }

  /// Firestore üzerinden kullanıcı profilini ve rolünü yükler.
  Future<void> _loadUserProfile(String uid, String email) async {
    try {
      final userModel = await userRepository.getUserProfile(uid);

      if (isClosed) return;

      if (userModel == null) {
        // Auth hesabı var ancak Firestore'da profil açılmamış
        emit(AuthPendingApproval(
          uid: uid,
          email: email,
          message: 'Hesap kaydınız bulundu ancak profiliniz veya rolünüz henüz tanımlanmamıştır.',
        ));
      } else if (!userModel.isActive) {
        // Hesap yönetici tarafından pasif yapılmış
        emit(AuthPendingApproval(
          uid: uid,
          email: email,
          message: 'Hesabınız yönetici tarafından askıya alınmıştır. Lütfen danışmanınızla görüşünüz.',
        ));
      } else {
        emit(Authenticated(userModel));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e is Failure ? e.message : 'Kullanıcı profili yüklenirken bir hata oluştu.'));
      }
    }
  }

  /// E-posta ve şifre ile giriş yapma işlemi.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading(message: 'Giriş yapılıyor...'));

    try {
      final credential = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      final userEmail = credential.user?.email ?? email;

      if (uid != null) {
        await _loadUserProfile(uid, userEmail);
      } else {
        emit(const AuthError('Kullanıcı kimliği alınamadı.'));
      }
    } on Failure catch (e) {
      if (!isClosed) emit(AuthError(e.message));
    } catch (e) {
      if (!isClosed) emit(AuthError('Giriş başarısız: $e'));
    }
  }

  /// Yeni öğrenci kaydı oluşturma işlemi.
  /// Güvenlik kuralı: Kayıt formundan yetkili rol (Danışman veya Şirket) verilemez, rol varsayılan olarak `student` atanır.
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading(message: 'Hesabınız oluşturuluyor...'));

    try {
      final credential = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        emit(const AuthError('Kullanıcı hesabı oluşturulamadı.'));
        return;
      }

      // Güvenli profil oluşturma: Yeni kayıtlar her zaman 'student' rolü alır
      final newUser = UserModel(
        uid: uid,
        fullName: fullName.trim(),
        email: email.trim(),
        role: UserRole.student,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await userRepository.createUserProfile(newUser);

      if (!isClosed) {
        emit(Authenticated(newUser));
      }
    } on Failure catch (e) {
      if (!isClosed) emit(AuthError(e.message));
    } catch (e) {
      if (!isClosed) emit(AuthError('Kayıt oluşturulurken bir hata oluştu: $e'));
    }
  }

  /// Şifre sıfırlama bağlantısı gönderme.
  Future<void> sendPasswordReset({required String email}) async {
    if (isClosed) return;
    emit(const AuthLoading(message: 'Sıfırlama bağlantısı gönderiliyor...'));

    try {
      await authRepository.sendPasswordResetEmail(email);
      if (!isClosed) {
        emit(PasswordResetSent(email));
      }
    } on Failure catch (e) {
      if (!isClosed) emit(AuthError(e.message));
    } catch (e) {
      if (!isClosed) emit(AuthError('Şifre sıfırlama başarısız: $e'));
    }
  }

  /// Oturumu kapatma işlemi.
  Future<void> signOut() async {
    try {
      await authRepository.signOut();
      if (!isClosed) {
        emit(const Unauthenticated());
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e is Failure ? e.message : 'Çıkış yapılırken bir hata oluştu.'));
      }
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
