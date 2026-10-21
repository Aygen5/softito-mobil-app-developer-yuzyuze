import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:staj_takip/data/models/daily_report_model.dart';
import 'package:staj_takip/data/models/internship_model.dart';
import 'package:staj_takip/data/models/user_model.dart';
import 'package:staj_takip/features/documents/services/pdf_generator_service.dart';

void main() {
  group('PdfGeneratorService Tests', () {
    late PdfGeneratorService service;

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
        tasks: 'Flutter UI ekranları tasarlandı.',
        learnings: 'Bloc mimarisi ve state yönetimi öğrenildi.',
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
      // Birim testlerin ağ bağlantısı olmadan anında (<10ms) çalışması için yerel fontları enjekte ediyoruz
      service = PdfGeneratorService(
        customRegularFont: pw.Font.helvetica(),
        customBoldFont: pw.Font.helveticaBold(),
      );
    });

    test('generateInternshipJournalPdf generates valid PDF bytes', () async {
      final bytes = await service.generateInternshipJournalPdf(
        student: testStudent,
        internship: testInternship,
        approvedReports: testReports,
      );

      expect(bytes, isNotEmpty);
      // PDF dosyaları her zaman %PDF- (bayt: 0x25, 0x50, 0x44, 0x46, 0x2D) ile başlar
      final header = String.fromCharCodes(bytes.take(5));
      expect(header, equals('%PDF-'));
    });

    test(
      'generateInternshipJournalPdf works even with empty approved reports',
      () async {
        final bytes = await service.generateInternshipJournalPdf(
          student: testStudent,
          internship: testInternship,
          approvedReports: const [],
        );

        expect(bytes, isNotEmpty);
        final header = String.fromCharCodes(bytes.take(5));
        expect(header, equals('%PDF-'));
      },
    );
  });
}
