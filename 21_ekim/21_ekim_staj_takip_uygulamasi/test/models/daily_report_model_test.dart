import 'package:flutter_test/flutter_test.dart';
import 'package:staj_takip/data/models/daily_report_model.dart';

void main() {
  group('DailyReportModel Tests', () {
    final workDate = DateTime(2026, 7, 5);
    final now = DateTime(2026, 7, 5, 17, 0);

    final report = DailyReportModel(
      id: 'rep_100',
      internshipId: 'intern_001',
      studentId: 'student_1',
      workDate: workDate,
      tasks: 'Flutter Bloc mimarisi incelendi ve state tanımları yapıldı.',
      learnings: 'Cubit durum akışlarının UI ile nasıl bağlandığı öğrenildi.',
      hoursWorked: 8,
      attachmentPaths: const ['report_attachments/ekran.png'],
      status: ReportStatus.submitted,
      companyApproved: true,
      advisorApproved: false,
      revisionComment: null,
      createdAt: now,
      updatedAt: now,
      submittedAt: now,
    );

    test(
      'toMap and fromMap should preserve approval flags and attachments',
      () {
        final map = report.toMap();
        expect(map['companyApproved'], isTrue);
        expect(map['advisorApproved'], isFalse);
        expect(map['status'], 'submitted');
        expect(map['hoursWorked'], 8);
        expect((map['attachmentPaths'] as List).length, 1);

        final deserialized = DailyReportModel.fromMap(map);
        expect(deserialized.id, report.id);
        expect(deserialized.companyApproved, isTrue);
        expect(deserialized.advisorApproved, isFalse);
        expect(deserialized.status.isSubmitted, isTrue);
        expect(
          deserialized.attachmentPaths.first,
          'report_attachments/ekran.png',
        );
      },
    );

    test('ReportStatus fromString checks', () {
      expect(ReportStatus.fromString('draft'), ReportStatus.draft);
      expect(ReportStatus.fromString('submitted'), ReportStatus.submitted);
      expect(ReportStatus.fromString('approved'), ReportStatus.approved);
      expect(
        ReportStatus.fromString('revisionRequested'),
        ReportStatus.revisionRequested,
      );
    });
  });
}
