import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/workday_calculator.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import 'internship_state.dart';

/// Staj ilerleme, takvim ve eksik gün tespiti motoru Cubit'i.
class InternshipCubit extends Cubit<InternshipState> {
  final String studentId;
  final InternshipRepository internshipRepository;
  final DailyReportRepository dailyReportRepository;

  StreamSubscription<InternshipModel?>? _internshipSubscription;
  StreamSubscription<List<DailyReportModel>>? _reportsSubscription;

  InternshipCubit({
    required this.studentId,
    required this.internshipRepository,
    required this.dailyReportRepository,
  }) : super(const InternshipInitial()) {
    init();
  }

  void init() {
    emit(const InternshipLoading());

    _internshipSubscription?.cancel();
    _internshipSubscription = internshipRepository
        .getActiveInternshipStream(studentId)
        .listen(
          (internship) {
            if (internship == null) {
              _reportsSubscription?.cancel();
              emit(const InternshipNoInternship());
            } else {
              _subscribeToReports(internship);
            }
          },
          onError: (error) {
            final failure =
                error is Failure ? error : Failure(error.toString());
            emit(InternshipError(failure.message));
          },
        );
  }

  void _subscribeToReports(InternshipModel internship) {
    _reportsSubscription?.cancel();
    _reportsSubscription = dailyReportRepository
        .getReportsForInternshipStream(internship.id)
        .listen(
          (reports) {
            _computeTimeline(internship, reports);
          },
          onError: (error) {
            final failure =
                error is Failure ? error : Failure(error.toString());
            emit(InternshipError(failure.message));
          },
        );
  }

  void _computeTimeline(
    InternshipModel internship,
    List<DailyReportModel> reports,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Raporları tarih bazlı haritada topla (hızlı erişim için)
    final reportsByDate = <String, DailyReportModel>{};
    for (final report in reports) {
      final key = _dateKey(report.workDate);
      reportsByDate[key] = report;
    }

    final timelineDays = <TimelineDay>[];
    int missingCount = 0;
    int approvedCount = 0;

    DateTime current = DateTime(
      internship.startDate.year,
      internship.startDate.month,
      internship.startDate.day,
    );
    final endDate = DateTime(
      internship.endDate.year,
      internship.endDate.month,
      internship.endDate.day,
    );

    while (!current.isAfter(endDate)) {
      if (!WorkdayCalculator.isWeekend(current)) {
        final key = _dateKey(current);
        final report = reportsByDate[key];

        TimelineDayStatus status;
        if (report != null) {
          switch (report.status) {
            case ReportStatus.approved:
              status = TimelineDayStatus.approved;
              approvedCount++;
              break;
            case ReportStatus.submitted:
              status = TimelineDayStatus.submitted;
              break;
            case ReportStatus.revisionRequested:
              status = TimelineDayStatus.revisionRequested;
              break;
            case ReportStatus.draft:
              status = TimelineDayStatus.draft;
              break;
          }
        } else {
          if (current.isBefore(today)) {
            status = TimelineDayStatus.missing;
            missingCount++;
          } else {
            status = TimelineDayStatus.future;
          }
        }

        timelineDays.add(
          TimelineDay(date: current, status: status, report: report),
        );
      }
      current = current.add(const Duration(days: 1));
    }

    final progressRatio = WorkdayCalculator.calculateProgressRatio(
      completedDays: approvedCount,
      requiredDays: internship.requiredDays,
    );

    emit(
      InternshipLoaded(
        internship: internship,
        reports: reports,
        timelineDays: timelineDays,
        missingDaysCount: missingCount,
        approvedDaysCount: approvedCount,
        totalWorkdaysCount: timelineDays.length,
        progressRatio: progressRatio,
      ),
    );
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
