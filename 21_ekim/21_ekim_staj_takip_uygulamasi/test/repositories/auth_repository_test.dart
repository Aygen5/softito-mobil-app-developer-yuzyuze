import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/core/errors/failure.dart';
import 'package:staj_takip/data/repositories/auth_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late FirebaseAuthRepository repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    repository = FirebaseAuthRepository(firebaseAuth: mockAuth);
  });

  group('FirebaseAuthRepository Tests', () {
    const testEmail = 'ogrenci@universite.edu.tr';
    const testPassword = 'Password123!';

    test(
      'signInWithEmailAndPassword returns UserCredential on success',
      () async {
        final mockCredential = MockUserCredential();
        when(
          () => mockAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => mockCredential);

        final result = await repository.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );

        expect(result, mockCredential);
        verify(
          () => mockAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      },
    );

    test('signInWithEmailAndPassword throws localized Failure on FirebaseAuthException', () async {
      when(
        () => mockAuth.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => repository.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
        throwsA(
          isA<Failure>().having(
            (f) => f.message,
            'message',
            contains('Bu e-posta adresine kayıtlı kullanıcı bulunamadı'),
          ),
        ),
      );
    });

    test('signOut calls FirebaseAuth.signOut', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
