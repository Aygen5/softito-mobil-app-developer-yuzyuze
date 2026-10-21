import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/core/errors/failure.dart';
import 'package:staj_takip/data/models/user_model.dart';
import 'package:staj_takip/data/repositories/auth_repository.dart';
import 'package:staj_takip/data/repositories/user_repository.dart';
import 'package:staj_takip/features/auth/cubit/auth_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUserRepository extends Mock implements UserRepository {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late StreamController<User?> authStateController;

  setUpAll(() {
    registerFallbackValue(
      UserModel(
        uid: 'fallback',
        fullName: 'Fallback',
        email: 'fallback@test.com',
        role: UserRole.student,
        createdAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    authStateController = StreamController<User?>();

    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
  });

  tearDown(() {
    authStateController.close();
  });

  final testUser = UserModel(
    uid: 'uid_123',
    fullName: 'Ahmet Yılmaz',
    email: 'ogrenci@staj.com',
    role: UserRole.student,
    isActive: true,
    createdAt: DateTime(2026, 10, 21),
  );

  group('AuthCubit Tests', () {
    test('initial state is AuthInitial', () {
      final cubit = AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      );
      expect(cubit.state, const AuthInitial());
      cubit.close();
    });

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when auth state stream emits null',
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) => authStateController.add(null),
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Authenticated] when auth stream emits user and Firestore profile exists',
      setUp: () {
        when(() => mockUserRepository.getUserProfile('uid_123'))
            .thenAnswer((_) async => testUser);
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('uid_123');
        when(() => mockUser.email).thenReturn('ogrenci@staj.com');
        authStateController.add(mockUser);
      },
      expect: () => [Authenticated(testUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthPendingApproval] when Firestore profile does not exist',
      setUp: () {
        when(() => mockUserRepository.getUserProfile('uid_new'))
            .thenAnswer((_) async => null);
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('uid_new');
        when(() => mockUser.email).thenReturn('yeni@staj.com');
        authStateController.add(mockUser);
      },
      expect: () => [
        isA<AuthPendingApproval>()
            .having((s) => s.uid, 'uid', 'uid_new')
            .having((s) => s.email, 'email', 'yeni@staj.com'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signIn emits [AuthLoading, Authenticated] on success',
      setUp: () {
        final mockCred = MockUserCredential();
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('uid_123');
        when(() => mockUser.email).thenReturn('ogrenci@staj.com');
        when(() => mockCred.user).thenReturn(mockUser);

        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'ogrenci@staj.com',
              password: 'Password123!',
            )).thenAnswer((_) async => mockCred);

        when(() => mockUserRepository.getUserProfile('uid_123'))
            .thenAnswer((_) async => testUser);
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) => cubit.signIn(
        email: 'ogrenci@staj.com',
        password: 'Password123!',
      ),
      expect: () => [
        const AuthLoading(message: 'Giriş yapılıyor...'),
        Authenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signIn emits [AuthLoading, AuthError] on failure',
      setUp: () {
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'hatali@staj.com',
              password: 'wrong',
            )).thenThrow(const Failure('E-posta veya şifre hatalı.'));
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) => cubit.signIn(
        email: 'hatali@staj.com',
        password: 'wrong',
      ),
      expect: () => [
        const AuthLoading(message: 'Giriş yapılıyor...'),
        const AuthError('E-posta veya şifre hatalı.'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signUp creates student profile and emits Authenticated',
      setUp: () {
        final mockCred = MockUserCredential();
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('new_student_uid');
        when(() => mockCred.user).thenReturn(mockUser);

        when(() => mockAuthRepository.signUpWithEmailAndPassword(
              email: 'yeni@staj.com',
              password: 'Password123!',
            )).thenAnswer((_) async => mockCred);

        when(() => mockUserRepository.createUserProfile(any()))
            .thenAnswer((_) async {});
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) => cubit.signUp(
        fullName: 'Yeni Öğrenci',
        email: 'yeni@staj.com',
        password: 'Password123!',
      ),
      expect: () => [
        const AuthLoading(message: 'Hesabınız oluşturuluyor...'),
        isA<Authenticated>()
            .having((s) => s.user.fullName, 'fullName', 'Yeni Öğrenci')
            .having((s) => s.user.role, 'role', UserRole.student),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'signOut calls repository and emits Unauthenticated',
      setUp: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
      },
      build: () => AuthCubit(
        authRepository: mockAuthRepository,
        userRepository: mockUserRepository,
      ),
      act: (cubit) => cubit.signOut(),
      expect: () => [const Unauthenticated()],
    );
  });
}
