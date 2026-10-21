import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/internship_model.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/features/daily_reports/cubit/daily_reports_cubit.dart';
import 'package:staj_takip/features/daily_reports/cubit/daily_reports_state.dart';

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

void main() {
  late MockInternshipRepository mockInternshipRepository;
  late MockDailyReportRepository mockDailyReportRepository;

  setUp(() {
    mockInternshipRepository = MockInternshipRepository();
    mockDailyReportRepository = MockDailyReportRepository();
  });

  final testInternship = InternshipModel(
    id: 'intern-1',
    studentId: 'student-123',
    companySupervisorId: 'sup-1',
    academicAdvisorId: 'adv-1',
    companyName: 'Tech Corp',
    startDate: DateTime(2026, 7, 1),
    endDate: DateTime(2026, 8, 15),
    requiredDays: 30,
    createdAt: DateTime.now(),
  );

  final testReports = [
    DailyReportModel(
      id: 'rep-1',
      internshipId: 'intern-1',
      studentId: 'student-123',
      workDate: DateTime(2026, 7, 1),
      tasks: 'Flutter UI geliştirme',
      learnings: 'Bloc mimarisi öğrenildi',
      hoursWorked: 8,
      status: ReportStatus.approved,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    DailyReportModel(
      id: 'rep-2',
      internshipId: 'intern-1',
      studentId: 'student-123',
      workDate: DateTime(2026, 7, 2),
      tasks: 'Firebase entegrasyonu',
      learnings: 'Firestore kuralları',
      hoursWorked: 6,
      status: ReportStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  test(
    'DailyReportsCubit emits DailyReportsNoInternship when internship is null',
    () async {
      when(
        () => mockInternshipRepository.getActiveInternshipStream('student-123'),
      ).thenAnswer((_) => Stream.value(null));

      final cubit = DailyReportsCubit(
        studentId: 'student-123',
        internshipRepository: mockInternshipRepository,
        dailyReportRepository: mockDailyReportRepository,
      );

      await expectLater(
        cubit.stream,
        emitsInOrder([const DailyReportsNoInternship()]),
      );

      await cubit.close();
    },
  );

  test('DailyReportsCubit filters by status correctly', () async {
    when(
      () => mockInternshipRepository.getActiveInternshipStream('student-123'),
    ).thenAnswer((_) => Stream.value(testInternship));
    when(
      () => mockDailyReportRepository.getReportsForInternshipStream('intern-1'),
    ).thenAnswer((_) => Stream.value(testReports));

    final cubit = DailyReportsCubit(
      studentId: 'student-123',
      internshipRepository: mockInternshipRepository,
      dailyReportRepository: mockDailyReportRepository,
    );

    // İlk yüklenme
    await expectLater(cubit.stream, emits(isA<DailyReportsLoaded>()));

    // Filtreleme: Yalnızca taslaklar (draft)
    cubit.setFilter(ReportStatus.draft);

    final state = cubit.state as DailyReportsLoaded;
    expect(state.filteredReports.length, 1);
    expect(state.filteredReports.first.id, 'rep-2');

    await cubit.close();
  });

  test('DailyReportsCubit filters by search query correctly', () async {
    when(
      () => mockInternshipRepository.getActiveInternshipStream('student-123'),
    ).thenAnswer((_) => Stream.value(testInternship));
    when(
      () => mockDailyReportRepository.getReportsForInternshipStream('intern-1'),
    ).thenAnswer((_) => Stream.value(testReports));

    final cubit = DailyReportsCubit(
      studentId: 'student-123',
      internshipRepository: mockInternshipRepository,
      dailyReportRepository: mockDailyReportRepository,
    );

    await expectLater(cubit.stream, emits(isA<DailyReportsLoaded>()));

    // Arama: "Firestore"
    cubit.setSearchQuery('firestore');

    final state = cubit.state as DailyReportsLoaded;
    expect(state.filteredReports.length, 1);
    expect(state.filteredReports.first.id, 'rep-2');

    await cubit.close();
  });
}
