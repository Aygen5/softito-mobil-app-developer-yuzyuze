import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/internship_model.dart';
import 'package:staj_takip/data/models/user_model.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/data/repositories/user_repository.dart';
import 'package:staj_takip/features/documents/cubit/documents_cubit.dart';
import 'package:staj_takip/features/documents/cubit/documents_state.dart';
import 'package:staj_takip/features/documents/services/pdf_generator_service.dart';

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('DocumentsCubit Tests', () {
    late MockDailyReportRepository mockDailyReportRepository;
    late MockInternshipRepository mockInternshipRepository;
    late MockUserRepository mockUserRepository;
    late PdfGeneratorService fastPdfService;

    final testStudent = UserModel(
      uid: 'student-1',
      email: 'student@example.com',
      fullName: 'Ahmet Yılmaz',
      role: UserRole.student,
      institutionId: '2024001',
      isActive: true,
      createdAt: DateTime(2026, 1, 1),
    );

    final testInternship = InternshipModel(
      id: 'intern-1',
      studentId: 'student-1',
      companySupervisorId: 'comp-1',
      academicAdvisorId: 'adv-1',
      companyName: 'Softito A.Ş.',
      startDate: DateTime(2026, 7, 1),
      endDate: DateTime(2026, 7, 31),
      requiredDays: 20,
      createdAt: DateTime(2026, 6, 1),
    );

    final testReports = [
      DailyReportModel(
        id: 'rep-1',
        internshipId: 'intern-1',
        studentId: 'student-1',
        workDate: DateTime(2026, 7, 1),
        tasks: 'Mobil arayüz kodlandı.',
        learnings: 'Flutter temelleri pekiştirildi.',
        hoursWorked: 8,
        attachmentPaths: const [],
        status: ReportStatus.approved,
        companyApproved: true,
        advisorApproved: true,
        createdAt: DateTime(2026, 7, 1, 18),
        updatedAt: DateTime(2026, 7, 1, 18),
      ),
    ];

    setUp(() {
      mockDailyReportRepository = MockDailyReportRepository();
      mockInternshipRepository = MockInternshipRepository();
      mockUserRepository = MockUserRepository();

      fastPdfService = PdfGeneratorService(
        customRegularFont: pw.Font.helvetica(),
        customBoldFont: pw.Font.helveticaBold(),
      );
    });

    test(
      'DocumentsCubit loads data and emits DocumentsLoaded with correct stats',
      () async {
        when(() => mockInternshipRepository.getInternshipById('intern-1'))
            .thenAnswer((_) async => testInternship);
        when(() => mockDailyReportRepository.getApprovedReports('intern-1'))
            .thenAnswer((_) async => testReports);
        when(() => mockUserRepository.getUserProfile('adv-1'))
            .thenAnswer((_) async => null);
        when(() => mockUserRepository.getUserProfile('comp-1'))
            .thenAnswer((_) async => null);

        final cubit = DocumentsCubit(
          internshipId: 'intern-1',
          student: testStudent,
          dailyReportRepository: mockDailyReportRepository,
          internshipRepository: mockInternshipRepository,
          userRepository: mockUserRepository,
          pdfGeneratorService: fastPdfService,
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<DocumentsLoaded>());
        final loadedState = cubit.state as DocumentsLoaded;
        expect(loadedState.approvedDaysCount, equals(1));
        expect(loadedState.totalRequiredDays, equals(20));
        expect(loadedState.hasMissingDays, isTrue);
        expect(loadedState.isFullyCompleted, isFalse);
        expect(loadedState.totalHours, equals(8));
        expect(loadedState.pdfBytes, isNotEmpty);

        await cubit.close();
      },
    );

    test(
      'DocumentsCubit emits DocumentsFailure when internship not found',
      () async {
        when(() => mockInternshipRepository.getInternshipById('not-found'))
            .thenAnswer((_) async => null);

        final cubit = DocumentsCubit(
          internshipId: 'not-found',
          student: testStudent,
          dailyReportRepository: mockDailyReportRepository,
          internshipRepository: mockInternshipRepository,
          userRepository: mockUserRepository,
          pdfGeneratorService: fastPdfService,
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(cubit.state, isA<DocumentsFailure>());
        final failureState = cubit.state as DocumentsFailure;
        expect(failureState.message, contains('Staj kaydı bulunamadı'));

        await cubit.close();
      },
    );
  });
}
