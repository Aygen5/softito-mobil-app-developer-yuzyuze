import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/internship_model.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:staj_takip/features/dashboard/cubit/dashboard_state.dart';

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

void main() {
  late MockInternshipRepository mockInternshipRepository;
  late MockDailyReportRepository mockDailyReportRepository;

  setUp(() {
    mockInternshipRepository = MockInternshipRepository();
    mockDailyReportRepository = MockDailyReportRepository();
  });

  test('DashboardCubit emits DashboardNoInternship when student has no active internship', () async {
    when(
      () => mockInternshipRepository.getActiveInternshipStream('student-123'),
    ).thenAnswer((_) => Stream.value(null));

    final cubit = DashboardCubit(
      studentId: 'student-123',
      internshipRepository: mockInternshipRepository,
      dailyReportRepository: mockDailyReportRepository,
    );

    await expectLater(
      cubit.stream,
      emitsInOrder([const DashboardNoInternship()]),
    );

    await cubit.close();
  });

  test('DashboardCubit computes stats and emits DashboardLoaded when internship and reports stream emit', () async {
    final internship = InternshipModel(
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

    final reports = [
      DailyReportModel(
        id: 'rep-1',
        internshipId: 'intern-1',
        studentId: 'student-123',
        workDate: DateTime(2026, 7, 1),
        tasks: 'Setup env',
        learnings: 'Flutter',
        hoursWorked: 8,
        status: ReportStatus.approved,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    when(
      () => mockInternshipRepository.getActiveInternshipStream('student-123'),
    ).thenAnswer((_) => Stream.value(internship));
    when(
      () => mockDailyReportRepository.getReportsForInternshipStream('intern-1'),
    ).thenAnswer((_) => Stream.value(reports));

    final cubit = DashboardCubit(
      studentId: 'student-123',
      internshipRepository: mockInternshipRepository,
      dailyReportRepository: mockDailyReportRepository,
    );

    await expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<DashboardState>((state) {
          if (state is! DashboardLoaded) return false;
          return state.stats.completedDays == 1 &&
              state.stats.totalRequiredDays == 30 &&
              state.stats.approvedCount == 1;
        }),
      ]),
    );

    await cubit.close();
  });
}
