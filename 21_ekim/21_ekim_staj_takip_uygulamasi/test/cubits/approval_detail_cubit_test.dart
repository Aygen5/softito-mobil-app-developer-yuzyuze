import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/review_model.dart';
import 'package:staj_takip/data/models/user_model.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/data/repositories/review_repository.dart';
import 'package:staj_takip/data/repositories/user_repository.dart';
import 'package:staj_takip/features/approvals/cubit/approval_detail_cubit.dart';
import 'package:staj_takip/features/approvals/cubit/approval_detail_state.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockReviewRepository mockReviewRepository;
  late MockInternshipRepository mockInternshipRepository;
  late MockUserRepository mockUserRepository;

  setUpAll(() {
    registerFallbackValue(
      ReviewModel(
        id: 'fallback-id',
        reportId: 'rep-1',
        reviewerId: 'rev-1',
        reviewerRole: UserRole.companyRepresentative,
        decision: ReviewDecision.approved,
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      DailyReportModel(
        id: 'rep-1',
        internshipId: 'intern-1',
        studentId: 'student-1',
        workDate: DateTime.now(),
        tasks: 't',
        learnings: 'l',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockReviewRepository = MockReviewRepository();
    mockInternshipRepository = MockInternshipRepository();
    mockUserRepository = MockUserRepository();
  });

  final testReport = DailyReportModel(
    id: 'rep-1',
    internshipId: 'intern-1',
    studentId: 'student-1',
    workDate: DateTime(2026, 7, 1),
    tasks: 'Task 1',
    learnings: 'Learning 1',
    hoursWorked: 8,
    status: ReportStatus.submitted,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final companyReviewer = UserModel(
    uid: 'company-user-1',
    email: 'company@staj.com',
    fullName: 'Şirket Sorumlusu',
    role: UserRole.companyRepresentative,
    createdAt: DateTime.now(),
  );

  test('ApprovalDetailCubit approves report successfully via batch', () async {
    when(() => mockReviewRepository.getReviewsForReport('rep-1'))
        .thenAnswer((_) async => []);
    when(() => mockInternshipRepository.getInternshipById('intern-1'))
        .thenAnswer((_) async => null);
    when(() => mockUserRepository.getUserProfile('student-1'))
        .thenAnswer((_) async => null);
    when(
      () => mockReviewRepository.submitReview(
        review: any(named: 'review'),
        updatedReport: any(named: 'updatedReport'),
      ),
    ).thenAnswer((_) async {});

    final cubit = ApprovalDetailCubit(
      initialReport: testReport,
      reviewer: companyReviewer,
      reviewRepository: mockReviewRepository,
      internshipRepository: mockInternshipRepository,
      userRepository: mockUserRepository,
    );

    // Bekle: initial load
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(cubit.state, isA<ApprovalDetailLoaded>());

    // Onayla
    await cubit.approve(comment: 'Harika çalışma');
    expect(cubit.state, isA<ApprovalDetailSuccess>());
    final success = cubit.state as ApprovalDetailSuccess;
    expect(success.isApproved, true);

    verify(
      () => mockReviewRepository.submitReview(
        review: any(named: 'review'),
        updatedReport: any(named: 'updatedReport'),
      ),
    ).called(1);

    await cubit.close();
  });

  test(
    'ApprovalDetailCubit requestRevision fails if comment is empty',
    () async {
      when(() => mockReviewRepository.getReviewsForReport('rep-1'))
          .thenAnswer((_) async => []);
      when(() => mockInternshipRepository.getInternshipById('intern-1'))
          .thenAnswer((_) async => null);
      when(() => mockUserRepository.getUserProfile('student-1'))
          .thenAnswer((_) async => null);

      final cubit = ApprovalDetailCubit(
        initialReport: testReport,
        reviewer: companyReviewer,
        reviewRepository: mockReviewRepository,
        internshipRepository: mockInternshipRepository,
        userRepository: mockUserRepository,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final states = <ApprovalDetailState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.requestRevision(comment: '   ');
      expect(states.any((s) => s is ApprovalDetailFailure), isTrue);

      await sub.cancel();
      await cubit.close();
    },
  );
}
