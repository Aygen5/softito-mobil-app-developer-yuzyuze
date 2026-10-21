import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../services/pdf_generator_service.dart';
import 'documents_state.dart';

/// PDF Staj Defteri üretim ve görüntüleme Cubit'i.
class DocumentsCubit extends Cubit<DocumentsState> {
  final String internshipId;
  final UserModel student;
  final DailyReportRepository dailyReportRepository;
  final InternshipRepository internshipRepository;
  final UserRepository userRepository;
  final PdfGeneratorService pdfGeneratorService;

  DocumentsCubit({
    required this.internshipId,
    required this.student,
    required this.dailyReportRepository,
    required this.internshipRepository,
    required this.userRepository,
    required this.pdfGeneratorService,
  }) : super(const DocumentsInitial()) {
    loadLogbook();
  }

  Future<void> loadLogbook() async {
    emit(
      const DocumentsLoading(message: 'Staj defteri verileri toplanıyor...'),
    );

    try {
      // 1. Staj Bilgisini Yükle
      final internship = await internshipRepository.getInternshipById(
        internshipId,
      );
      if (internship == null) {
        emit(const DocumentsFailure('Staj kaydı bulunamadı.'));
        return;
      }

      // 2. Yalnızca Çift Aşamalı Onayı Tamamlanmış Raporları Çek
      final approvedReports = await dailyReportRepository.getApprovedReports(
        internshipId,
      );

      // 3. Yetkili Bilgilerini Yükle
      UserModel? advisor;
      UserModel? companySupervisor;

      if (internship.academicAdvisorId != null &&
          internship.academicAdvisorId!.isNotEmpty) {
        advisor = await userRepository.getUserProfile(
          internship.academicAdvisorId!,
        );
      }

      if (internship.companySupervisorId != null &&
          internship.companySupervisorId!.isNotEmpty) {
        companySupervisor = await userRepository.getUserProfile(
          internship.companySupervisorId!,
        );
      }

      emit(const DocumentsLoading(message: 'PDF staj defteri derleniyor...'));

      // 4. PDF Baytlarını Üret
      final pdfBytes = await pdfGeneratorService.generateInternshipJournalPdf(
        student: student,
        internship: internship,
        approvedReports: approvedReports,
        advisor: advisor,
        companySupervisor: companySupervisor,
      );

      emit(
        DocumentsLoaded(
          student: student,
          internship: internship,
          approvedReports: approvedReports,
          advisor: advisor,
          companySupervisor: companySupervisor,
          pdfBytes: pdfBytes,
        ),
      );
    } on Failure catch (e) {
      emit(DocumentsFailure(e.message));
    } catch (e) {
      emit(DocumentsFailure(e.toString()));
    }
  }

  Future<void> regenerate() async {
    await loadLogbook();
  }
}
