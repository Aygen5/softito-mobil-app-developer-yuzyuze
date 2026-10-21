import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/user_model.dart';
import 'package:staj_takip/data/repositories/auth_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/data/repositories/user_repository.dart';
import 'package:staj_takip/features/profile/cubit/profile_cubit.dart';
import 'package:staj_takip/features/profile/cubit/profile_state.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockInternshipRepository mockInternshipRepository;
  late MockAuthRepository mockAuthRepository;

  final testUser = UserModel(
    uid: 'user-1',
    fullName: 'Test Öğrenci',
    email: 'ogrenci@test.com',
    role: UserRole.student,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockInternshipRepository = MockInternshipRepository();
    mockAuthRepository = MockAuthRepository();
  });

  test('ProfileCubit loads profile and emits ProfileLoaded', () async {
    when(() => mockUserRepository.getUserProfile('user-1'))
        .thenAnswer((_) async => testUser);
    when(() => mockInternshipRepository.getActiveInternshipForStudent('user-1'))
        .thenAnswer((_) async => null);

    final cubit = ProfileCubit(
      initialUser: testUser,
      userRepository: mockUserRepository,
      internshipRepository: mockInternshipRepository,
      authRepository: mockAuthRepository,
    );

    // Constructor senkron olarak ProfileLoading emit eder
    expect(cubit.state, isA<ProfileLoading>());

    // Asenkron veri yüklendikten sonra ProfileLoaded emit edilir
    await expectLater(
      cubit.stream,
      emits(ProfileLoaded(user: testUser, activeInternship: null)),
    );

    await cubit.close();
  });

  test('ProfileCubit signOut delegates to AuthRepository', () async {
    when(() => mockUserRepository.getUserProfile('user-1'))
        .thenAnswer((_) async => testUser);
    when(() => mockInternshipRepository.getActiveInternshipForStudent('user-1'))
        .thenAnswer((_) async => null);
    when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

    final cubit = ProfileCubit(
      initialUser: testUser,
      userRepository: mockUserRepository,
      internshipRepository: mockInternshipRepository,
      authRepository: mockAuthRepository,
    );

    // Profil yüklenmesini bekle
    await expectLater(cubit.stream, emits(isA<ProfileLoaded>()));

    await cubit.signOut();

    verify(() => mockAuthRepository.signOut()).called(1);
    await cubit.close();
  });
}
