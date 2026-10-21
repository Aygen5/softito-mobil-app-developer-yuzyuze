import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'approval_detail_state.dart';

/// Rapor onaylama, düzeltme isteme ve puanlama Cubit'i.
class ApprovalDetailCubit extends Cubit<ApprovalDetailState> {
  final DailyReportModel initialReport;
  final UserModel reviewer;
  final ReviewRepository reviewRepository;
  final InternshipRepository internshipRepository;
  final UserRepository userRepository;

  ApprovalDetailCubit({
    required this.initialReport,
    required this.reviewer,
    required this.reviewRepository,
    required this.internshipRepository,
    required this.userRepository,
  }) : super(const ApprovalDetailInitial()) {
    init();
  }

  Future<void> init() async {
    emit(const ApprovalDetailLoading());

    try {
      final reviews =
          await reviewRepository.getReviewsForReport(initialReport.id);
      final internship = await internshipRepository
          .getInternshipById(initialReport.internshipId);
      final student =
          await userRepository.getUserProfile(initialReport.studentId);

      emit(
        ApprovalDetailLoaded(
          report: initialReport,
          internship: internship,
          student: student,
          reviews: reviews,
        ),
      );
    } on Failure catch (e) {
      emit(ApprovalDetailFailure(e.message));
    } catch (e) {
      emit(ApprovalDetailFailure(e.toString()));
    }
  }

  Future<void> approve({int? score, String? comment}) async {
    final currentState = state;
    if (currentState is! ApprovalDetailLoaded) return;

    emit(
      const ApprovalDetailLoading(
        message: 'Onay işlemi kaydediliyor...',
      ),
    );

    try {
      final now = DateTime.now();
      final currentReport = currentState.report;

      DailyReportModel updatedReport;
      if (reviewer.role.isCompany) {
        // Kurum yetkilisi onayı
        updatedReport = currentReport.copyWith(
          companyApproved: true,
          updatedAt: now,
        );
      } else {
        // Danışman onayı (Nihai Onay)
        updatedReport = currentReport.copyWith(
          advisorApproved: true,
          status: ReportStatus.approved,
          updatedAt: now,
        );
      }

      final review = ReviewModel(
        id: '',
        reportId: currentReport.id,
        reviewerId: reviewer.uid,
        reviewerRole: reviewer.role,
        decision: ReviewDecision.approved,
        comment: comment ??
            (reviewer.role.isCompany
                ? 'Kurum yetkilisi tarafından onaylandı.'
                : 'Akademik danışman tarafından onaylandı.'),
        score: score?.toDouble(),
        createdAt: now,
      );

      await reviewRepository.submitReview(
        review: review,
        updatedReport: updatedReport,
      );

      emit(
        ApprovalDetailSuccess(
          message: reviewer.role.isCompany
              ? 'Rapor kurum düzeyinde onaylandı ve danışman incelemesine iletildi.'
              : 'Rapor nihai olarak onaylandı ve staj defterine işlendi.',
          isApproved: true,
        ),
      );
    } on Failure catch (e) {
      emit(ApprovalDetailFailure(e.message));
      emit(currentState);
    } catch (e) {
      emit(ApprovalDetailFailure(e.toString()));
      emit(currentState);
    }
  }

  Future<void> requestRevision({required String comment}) async {
    final currentState = state;
    if (currentState is! ApprovalDetailLoaded) return;

    if (comment.trim().isEmpty) {
      emit(
        const ApprovalDetailFailure(
          'Düzeltme talebi için açıklama girilmesi zorunludur.',
        ),
      );
      emit(currentState);
      return;
    }

    emit(
      const ApprovalDetailLoading(
        message: 'Düzeltme talebi kaydediliyor...',
      ),
    );

    try {
      final now = DateTime.now();
      final currentReport = currentState.report;

      final updatedReport = currentReport.copyWith(
        status: ReportStatus.revisionRequested,
        revisionComment: comment.trim(),
        updatedAt: now,
      );

      final review = ReviewModel(
        id: '',
        reportId: currentReport.id,
        reviewerId: reviewer.uid,
        reviewerRole: reviewer.role,
        decision: ReviewDecision.revisionRequested,
        comment: comment.trim(),
        createdAt: now,
      );

      await reviewRepository.submitReview(
        review: review,
        updatedReport: updatedReport,
      );

      emit(
        const ApprovalDetailSuccess(
          message: 'Düzeltme talebi öğrenciye iletildi.',
          isApproved: false,
        ),
      );
    } on Failure catch (e) {
      emit(ApprovalDetailFailure(e.message));
      emit(currentState);
    } catch (e) {
      emit(ApprovalDetailFailure(e.toString()));
      emit(currentState);
    }
  }
}
