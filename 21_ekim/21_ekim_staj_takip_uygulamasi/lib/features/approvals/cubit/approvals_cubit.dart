import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'approvals_state.dart';

/// İnceleme bekleyen raporları filtreleyen ve listeleyen Cubit.
class ApprovalsCubit extends Cubit<ApprovalsState> {
  final String reviewerId;
  final UserRole reviewerRole;
  final InternshipRepository internshipRepository;
  final DailyReportRepository dailyReportRepository;
  final UserRepository userRepository;

  ApprovalsCubit({
    required this.reviewerId,
    required this.reviewerRole,
    required this.internshipRepository,
    required this.dailyReportRepository,
    required this.userRepository,
  }) : super(const ApprovalsInitial()) {
    loadPendingReports();
  }

  Future<void> loadPendingReports() async {
    emit(const ApprovalsLoading());

    try {
      // 1. Yetkiliye atanmış stajları al
      final List<InternshipModel> internships;
      if (reviewerRole.isCompany) {
        internships = await internshipRepository.getInternshipsForSupervisor(
          reviewerId,
        );
      } else {
        internships = await internshipRepository.getInternshipsForAdvisor(
          reviewerId,
        );
      }

      if (internships.isEmpty) {
        emit(
          const ApprovalsEmpty(
            message: 'Tarafınıza atanmış aktif staj kaydı bulunmuyor.',
            totalInternsCount: 0,
          ),
        );
        return;
      }

      final internshipIds = internships.map((e) => e.id).toList();
      final internshipsMap = {for (var i in internships) i.id: i};

      // 2. Bu stajlara ait 'submitted' durumdaki raporları çek
      final rawReports = await dailyReportRepository.getPendingReportsForReview(
        internshipIds: internshipIds,
      );

      // 3. Role göre filtrele:
      // Şirket yetkilisi henüz kurum onayı verilmemişleri görür:
      // Danışman ise kurum onayından geçmiş ama danışman onayı bekleyenleri görür:
      final List<DailyReportModel> pendingReports;
      if (reviewerRole.isCompany) {
        pendingReports = rawReports.where((r) => !r.companyApproved).toList();
      } else {
        pendingReports = rawReports
            .where((r) => r.companyApproved && !r.advisorApproved)
            .toList();
      }

      // 4. Öğrenci profillerini al
      final studentIds = internships.map((e) => e.studentId).toSet().toList();
      final studentsMap = <String, UserModel>{};

      for (final sId in studentIds) {
        final profile = await userRepository.getUserProfile(sId);
        if (profile != null) {
          studentsMap[sId] = profile;
        }
      }

      if (pendingReports.isEmpty) {
        emit(
          ApprovalsEmpty(
            message: reviewerRole.isCompany
                ? 'Kurum incelemesi bekleyen yeni bir rapor bulunmuyor.'
                : 'Kurum onayından geçmiş akademik inceleme bekleyen rapor bulunmuyor.',
            totalInternsCount: internships.length,
          ),
        );
      } else {
        emit(
          ApprovalsLoaded(
            pendingReports: pendingReports,
            internships: internshipsMap,
            students: studentsMap,
            totalInternsCount: internships.length,
          ),
        );
      }
    } on Failure catch (e) {
      emit(ApprovalsError(e.message));
    } catch (e) {
      emit(ApprovalsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadPendingReports();
  }
}
