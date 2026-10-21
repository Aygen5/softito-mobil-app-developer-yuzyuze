import 'package:equatable/equatable.dart';

import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';

/// Günlük raporlar listesi durumları.
sealed class DailyReportsState extends Equatable {
  const DailyReportsState();

  @override
  List<Object?> get props => [];
}

class DailyReportsInitial extends DailyReportsState {
  const DailyReportsInitial();
}

class DailyReportsLoading extends DailyReportsState {
  const DailyReportsLoading();
}

class DailyReportsNoInternship extends DailyReportsState {
  const DailyReportsNoInternship();
}

class DailyReportsLoaded extends DailyReportsState {
  final InternshipModel internship;
  final List<DailyReportModel> allReports;
  final List<DailyReportModel> filteredReports;
  final ReportStatus? selectedFilter;
  final String searchQuery;

  const DailyReportsLoaded({
    required this.internship,
    required this.allReports,
    required this.filteredReports,
    this.selectedFilter,
    this.searchQuery = '',
  });

  DailyReportsLoaded copyWith({
    InternshipModel? internship,
    List<DailyReportModel>? allReports,
    List<DailyReportModel>? filteredReports,
    ReportStatus? Function()? selectedFilter,
    String? searchQuery,
  }) {
    return DailyReportsLoaded(
      internship: internship ?? this.internship,
      allReports: allReports ?? this.allReports,
      filteredReports: filteredReports ?? this.filteredReports,
      selectedFilter: selectedFilter != null
          ? selectedFilter()
          : this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    internship,
    allReports,
    filteredReports,
    selectedFilter,
    searchQuery,
  ];
}

class DailyReportsError extends DailyReportsState {
  final String message;

  const DailyReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
