import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/workday_calculator.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import 'dashboard_state.dart';

/// Öğrenci ana paneli Cubit'i.
/// Aktif stajı ve staja ait günlük raporları izler, istatistikleri hesaplar.
class DashboardCubit extends Cubit<DashboardState> {
  final String studentId;
  final InternshipRepository internshipRepository;
  final DailyReportRepository dailyReportRepository;

  StreamSubscription<InternshipModel?>? _internshipSubscription;
  StreamSubscription<List<DailyReportModel>>? _reportsSubscription;

  DashboardCubit({
    required this.studentId,
    required this.internshipRepository,
    required this.dailyReportRepository,
  }) : super(const DashboardInitial()) {
    init();
  }

  void init() {
    emit(const DashboardLoading());

    _internshipSubscription?.cancel();
    _internshipSubscription = internshipRepository
        .getActiveInternshipStream(studentId)
        .listen(
          (internship) {
            if (internship == null) {
              _reportsSubscription?.cancel();
              emit(const DashboardNoInternship());
            } else {
              _subscribeToReports(internship);
            }
          },
          onError: (error) {
            final failure =
                error is Failure ? error : Failure(error.toString());
            emit(DashboardError(failure.message));
          },
        );
  }

  void _subscribeToReports(InternshipModel internship) {
    _reportsSubscription?.cancel();
    _reportsSubscription = dailyReportRepository
        .getReportsForInternshipStream(internship.id)
        .listen(
          (reports) {
            final stats = _computeStats(internship, reports);
            emit(
              DashboardLoaded(
                internship: internship,
                reports: reports,
                stats: stats,
              ),
            );
          },
          onError: (error) {
            final failure =
                error is Failure ? error : Failure(error.toString());
            emit(DashboardError(failure.message));
          },
        );
  }

  DashboardStats _computeStats(
    InternshipModel internship,
    List<DailyReportModel> reports,
  ) {
    int approvedCount = 0;
    int pendingCount = 0;
    int revisionCount = 0;
    int draftCount = 0;

    for (final report in reports) {
      switch (report.status) {
        case ReportStatus.approved:
          approvedCount++;
          break;
        case ReportStatus.submitted:
          pendingCount++;
          break;
        case ReportStatus.revisionRequested:
          revisionCount++;
          break;
        case ReportStatus.draft:
          draftCount++;
          break;
      }
    }

    // Tamamlanan gün sayısı = Onaylanan benzersiz rapor sayısı
    final completedDays = approvedCount;
    final totalDays = internship.requiredDays;
    final ratio = WorkdayCalculator.calculateProgressRatio(
      completedDays: completedDays,
      requiredDays: totalDays,
    );

    return DashboardStats(
      totalRequiredDays: totalDays,
      completedDays: completedDays,
      progressRatio: ratio,
      approvedCount: approvedCount,
      pendingCount: pendingCount,
      revisionCount: revisionCount,
      draftCount: draftCount,
    );
  }

  Future<void> refresh() async {
    init();
  }

  @override
  Future<void> close() {
    _internshipSubscription?.cancel();
    _reportsSubscription?.cancel();
    return super.close();
  }
}
