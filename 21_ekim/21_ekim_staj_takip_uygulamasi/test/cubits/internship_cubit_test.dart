import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/internship_model.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/features/internship/cubit/internship_cubit.dart';
import 'package:staj_takip/features/internship/cubit/internship_state.dart';

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

void main() {
  late MockInternshipRepository mockInternshipRepository;
  late MockDailyReportRepository mockDailyReportRepository;

  setUp(() {
    mockInternshipRepository = MockInternshipRepository();
    mockDailyReportRepository = MockDailyReportRepository();
  });

  test(
    'InternshipCubit emits InternshipNoInternship when internship is null',
    () async {
      when(
        () => mockInternshipRepository.getActiveInternshipStream('student-123'),
      ).thenAnswer((_) => Stream.value(null));

      final cubit = InternshipCubit(
        studentId: 'student-123',
        internshipRepository: mockInternshipRepository,
        dailyReportRepository: mockDailyReportRepository,
      );

      await expectLater(
        cubit.stream,
        emitsInOrder([const InternshipNoInternship()]),
      );

      await cubit.close();
    },
  );

  test(
    'InternshipCubit calculates progress and detects timeline properly',
    () async {
      final internship = InternshipModel(
        id: 'intern-1',
        studentId: 'student-123',
        companySupervisorId: 'sup-1',
        academicAdvisorId: 'adv-1',
        companyName: 'Tech Corp',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 5), // 5 iş günü (Pzt - Cuma)
        requiredDays: 20,
        createdAt: DateTime.now(),
      );

      final reports = [
        DailyReportModel(
          id: 'rep-1',
          internshipId: 'intern-1',
          studentId: 'student-123',
          workDate: DateTime(2026, 6, 1),
          tasks: 'Başlangıç',
          learnings: 'Tanıtım',
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
        () =>
            mockDailyReportRepository.getReportsForInternshipStream('intern-1'),
      ).thenAnswer((_) => Stream.value(reports));

      final cubit = InternshipCubit(
        studentId: 'student-123',
        internshipRepository: mockInternshipRepository,
        dailyReportRepository: mockDailyReportRepository,
      );

      await expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<InternshipState>((state) {
            if (state is! InternshipLoaded) return false;
            return state.approvedDaysCount == 1 &&
                state.totalWorkdaysCount == 5 &&
                state.timelineDays.isNotEmpty;
          }),
        ]),
      );

      await cubit.close();
    },
  );
}
