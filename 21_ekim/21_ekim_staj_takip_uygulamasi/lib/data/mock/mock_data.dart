import '../models/daily_report_model.dart';
import '../models/internship_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';

/// Test, demo ve görsel doğrulama için Stitch tasarımlarıyla %100 uyumlu zengin mock veri seti.
abstract final class MockData {
  // --- KULLANICILAR ---
  static final UserModel studentUser = UserModel(
    uid: 'demo_student_uid',
    fullName: 'Aygen Yıldırım',
    email: 'ogrenci@test.com',
    role: UserRole.student,
    institutionId: '2024-STJ-042',
    isActive: true,
    createdAt: DateTime(2026, 9, 1),
  );

  static final UserModel companyUser = UserModel(
    uid: 'demo_company_uid',
    fullName: 'Murat Yılmaz',
    email: 'sirket@test.com',
    role: UserRole.companyRepresentative,
    institutionId: 'TCK-8841',
    isActive: true,
    createdAt: DateTime(2026, 8, 15),
  );

  static final UserModel advisorUser = UserModel(
    uid: 'demo_advisor_uid',
    fullName: 'Doç. Dr. Selin Kaya',
    email: 'danisman@test.com',
    role: UserRole.academicAdvisor,
    institutionId: 'AKD-1092',
    isActive: true,
    createdAt: DateTime(2026, 8, 1),
  );

  // --- STAJ KAYDI ---
  static InternshipModel defaultInternship({String? studentId}) {
    return InternshipModel(
      id: 'staj_demo_001',
      studentId: studentId ?? 'demo_student_uid',
      companySupervisorId: 'demo_company_uid',
      academicAdvisorId: 'demo_advisor_uid',
      companyName: 'TechVanguard Yazılım & Ar-Ge A.Ş.',
      startDate: DateTime(2026, 9, 7),
      endDate: DateTime(2026, 11, 2),
      requiredDays: 40,
      status: InternshipStatus.active,
      createdAt: DateTime(2026, 9, 1),
    );
  }

  // --- GÜNLÜK RAPORLAR ---
  static List<DailyReportModel> defaultDailyReports({
    String internshipId = 'staj_demo_001',
    String studentId = 'demo_student_uid',
  }) {
    final now = DateTime.now();

    return [
      DailyReportModel(
        id: 'rep_005',
        internshipId: internshipId,
        studentId: studentId,
        workDate: now,
        tasks: 'Stitch UI Tasarım Sistemi Uyumlandırması & Responsive İyileştirmeler',
        learnings: 'Farklı mobil ekran boyutlarında taşmaları önlemek için esnek flex yapıları ve tema renk standartlarını uyguladım.',
        hoursWorked: 8,
        status: ReportStatus.draft,
        companyApproved: false,
        advisorApproved: false,
        createdAt: now,
        updatedAt: now,
      ),
      DailyReportModel(
        id: 'rep_004',
        internshipId: internshipId,
        studentId: studentId,
        workDate: now.subtract(const Duration(days: 1)),
        tasks: 'Mobil Arayüz Testleri & GoRouter Rota Koruması',
        learnings: 'Widget testlerinde Mocktail ile sahte repository nesneleri oluşturup kimlik doğrulama yönlendirmelerini doğruladım.',
        hoursWorked: 8,
        status: ReportStatus.revisionRequested,
        companyApproved: false,
        advisorApproved: false,
        revisionComment: 'Lütfen yapılan test senaryolarının kapsamını ve test dosyası isimlerini raporda detaylandırınız.',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      DailyReportModel(
        id: 'rep_003',
        internshipId: internshipId,
        studentId: studentId,
        workDate: now.subtract(const Duration(days: 2)),
        tasks: 'PDF Staj Defteri Rapor Çıktısı & Font Fallback Optimizasyonu',
        learnings: 'Dart pdf paketiyle resmî belge oluşturma, çift onaylı mühür ve dijital imza kutuları tasarımı gerçekleştirdim.',
        hoursWorked: 8,
        status: ReportStatus.submitted,
        companyApproved: true,
        advisorApproved: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
        submittedAt: now.subtract(const Duration(days: 2)),
      ),
      DailyReportModel(
        id: 'rep_002',
        internshipId: internshipId,
        studentId: studentId,
        workDate: now.subtract(const Duration(days: 3)),
        tasks: 'Cloud Firestore Koleksiyon Şeması & Veri Modellemesi',
        learnings: 'NoSQL veritabanı optimizasyonu, ilişkisel olmayan veri yapılarında referans kimlikleri yönetimi ve güvenlik kuralları yazımı pratiği edindim.',
        hoursWorked: 8,
        status: ReportStatus.approved,
        companyApproved: true,
        advisorApproved: true,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        submittedAt: now.subtract(const Duration(days: 3)),
      ),
      DailyReportModel(
        id: 'rep_001',
        internshipId: internshipId,
        studentId: studentId,
        workDate: now.subtract(const Duration(days: 4)),
        tasks: 'Flutter BLoC Durum Yönetimi & Repository Entegrasyonu',
        learnings: 'UI katmanı ile veri katmanı arasındaki asenkron veri akışını ayrıştırdım, Clean Architecture prensiplerine uygun test edilebilir state yapısı kurdum.',
        hoursWorked: 8,
        status: ReportStatus.approved,
        companyApproved: true,
        advisorApproved: true,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
        submittedAt: now.subtract(const Duration(days: 4)),
      ),
    ];
  }

  // --- İNCELEME GEÇMİŞİ ---
  static List<ReviewModel> defaultReviewsForReport(String reportId) {
    if (reportId == 'rep_004') {
      return [
        ReviewModel(
          id: 'rev_003',
          reportId: 'rep_004',
          reviewerId: 'demo_company_uid',
          reviewerRole: UserRole.companyRepresentative,
          decision: ReviewDecision.requestRevision,
          comment: 'Lütfen yapılan test senaryolarının kapsamını ve test dosyası isimlerini raporda detaylandırınız.',
          score: 60.0,
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ];
    }

    if (reportId == 'rep_003') {
      return [
        ReviewModel(
          id: 'rev_002',
          reportId: 'rep_003',
          reviewerId: 'demo_company_uid',
          reviewerRole: UserRole.companyRepresentative,
          decision: ReviewDecision.approve,
          comment: 'Rapor formatı uygun, şirket içi değerlendirme tamamlandı.',
          score: 95.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    }

    return [
      ReviewModel(
        id: 'rev_001_c',
        reportId: reportId,
        reviewerId: 'demo_company_uid',
        reviewerRole: UserRole.companyRepresentative,
        decision: ReviewDecision.approve,
        comment: 'Kurum onay kriterlerini karşılıyor.',
        score: 100.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'rev_001_a',
        reportId: reportId,
        reviewerId: 'demo_advisor_uid',
        reviewerRole: UserRole.academicAdvisor,
        decision: ReviewDecision.approve,
        comment: 'Akademik hedeflerle tam uyumlu.',
        score: 100.0,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
