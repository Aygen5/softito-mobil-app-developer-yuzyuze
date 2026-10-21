import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import 'daily_reports_state.dart';

/// Günlük raporlar listeleme, arama ve filtreleme Cubit'i.
class DailyReportsCubit extends Cubit<DailyReportsState> {
  final String studentId;
  final InternshipRepository internshipRepository;
  final DailyReportRepository dailyReportRepository;

  StreamSubscription<InternshipModel?>? _internshipSubscription;
  StreamSubscription<List<DailyReportModel>>? _reportsSubscription;

  InternshipModel? _internship;
  List<DailyReportModel> _allReports = [];
  ReportStatus? _currentFilter;
  String _currentQuery = '';

  DailyReportsCubit({
    required this.studentId,
    required this.internshipRepository,
    required this.dailyReportRepository,
  }) : super(const DailyReportsInitial()) {
    init();
  }

  void init() {
    emit(const DailyReportsLoading());

    _internshipSubscription?.cancel();
    _internshipSubscription = internshipRepository
        .getActiveInternshipStream(studentId)
        .listen(
          (internship) {
            _internship = internship;
            if (internship == null) {
              _reportsSubscription?.cancel();
              emit(const DailyReportsNoInternship());
            } else {
              _subscribeToReports(internship);
            }
          },
          onError: (error) {
            final failure = error is Failure
                ? error
                : Failure(error.toString());
            emit(DailyReportsError(failure.message));
          },
        );
  }

  void _subscribeToReports(InternshipModel internship) {
    _reportsSubscription?.cancel();
    _reportsSubscription = dailyReportRepository
        .getReportsForInternshipStream(internship.id)
        .listen(
          (reports) {
            _allReports = reports;
            _applyFilters();
          },
          onError: (error) {
            final failure = error is Failure
                ? error
                : Failure(error.toString());
            emit(DailyReportsError(failure.message));
          },
        );
  }

  void setFilter(ReportStatus? status) {
    _currentFilter = status;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _currentQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    if (_internship == null) return;

    List<DailyReportModel> filtered = _allReports;

    // Durum filtresi
    if (_currentFilter != null) {
      filtered = filtered
          .where((report) => report.status == _currentFilter)
          .toList();
    }

    // Arama filtresi
    if (_currentQuery.isNotEmpty) {
      filtered = filtered.where((report) {
        final tasksMatch = report.tasks.toLowerCase().contains(_currentQuery);
        final learningsMatch = report.learnings.toLowerCase().contains(
          _currentQuery,
        );
        return tasksMatch || learningsMatch;
      }).toList();
    }

    emit(
      DailyReportsLoaded(
        internship: _internship!,
        allReports: _allReports,
        filteredReports: filtered,
        selectedFilter: _currentFilter,
        searchQuery: _currentQuery,
      ),
    );
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await dailyReportRepository.deleteReport(reportId);
    } on Failure catch (e) {
      emit(DailyReportsError(e.message));
      _applyFilters();
    } catch (e) {
      emit(DailyReportsError(e.toString()));
      _applyFilters();
    }
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
