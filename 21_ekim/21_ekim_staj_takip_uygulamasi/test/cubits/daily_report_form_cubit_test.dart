import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/document_repository.dart';
import 'package:staj_takip/features/daily_reports/cubit/daily_report_form_cubit.dart';
import 'package:staj_takip/features/daily_reports/cubit/daily_report_form_state.dart';

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class FakeDailyReportModel extends Fake implements DailyReportModel {}

void main() {
  late MockDailyReportRepository mockDailyReportRepository;
  late MockDocumentRepository mockDocumentRepository;

  setUpAll(() {
    registerFallbackValue(FakeDailyReportModel());
  });

  setUp(() {
    mockDailyReportRepository = MockDailyReportRepository();
    mockDocumentRepository = MockDocumentRepository();
  });

  test('DailyReportFormCubit flags weekend dates as invalid', () async {
    final cubit = DailyReportFormCubit(
      internshipId: 'intern-1',
      studentId: 'student-1',
      dailyReportRepository: mockDailyReportRepository,
      documentRepository: mockDocumentRepository,
    );

    // 2026-06-06 Cumartesi günüdür
    final saturday = DateTime(2026, 6, 6);
    await cubit.updateWorkDate(saturday);

    final state = cubit.state as DailyReportFormReady;
    expect(state.dateError, 'Hafta sonu günlerine rapor girilemez.');

    await cubit.close();
  });

  test(
    'DailyReportFormCubit prevents save when tasks or learnings empty',
    () async {
      final cubit = DailyReportFormCubit(
        internshipId: 'intern-1',
        studentId: 'student-1',
        dailyReportRepository: mockDailyReportRepository,
        documentRepository: mockDocumentRepository,
      );

      // Tasks ve learnings boşken saveDraft çağrısı
      await cubit.saveDraft();

      // Failure mesajı yayınlanmış olmalı
      verifyNever(() => mockDailyReportRepository.createReport(any()));
      await cubit.close();
    },
  );

  test(
    'DailyReportFormCubit saves draft successfully when form is valid',
    () async {
      when(() => mockDailyReportRepository.createReport(any()))
          .thenAnswer((_) async {});

      final cubit = DailyReportFormCubit(
        internshipId: 'intern-1',
        studentId: 'student-1',
        dailyReportRepository: mockDailyReportRepository,
        documentRepository: mockDocumentRepository,
      );

      // 2026-06-05 Cuma iş günüdür
      when(
        () => mockDailyReportRepository.hasReportOnDate(
          internshipId: 'intern-1',
          date: any(named: 'date'),
          excludeReportId: any(named: 'excludeReportId'),
        ),
      ).thenAnswer((_) async => false);

      await cubit.updateWorkDate(DateTime(2026, 6, 5));
      cubit.updateTasks('Mobil ekran tasarımı yapıldı.');
      cubit.updateLearnings('State management pratik edildi.');

      await cubit.saveDraft();

      verify(() => mockDailyReportRepository.createReport(any())).called(1);
      expect(cubit.state, isA<DailyReportFormSuccess>());
      final successState = cubit.state as DailyReportFormSuccess;
      expect(successState.wasSubmitted, false);

      await cubit.close();
    },
  );
}
