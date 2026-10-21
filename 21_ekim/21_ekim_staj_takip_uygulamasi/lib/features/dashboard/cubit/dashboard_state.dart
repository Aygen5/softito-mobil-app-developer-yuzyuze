import 'package:equatable/equatable.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';

/// Öğrenci paneli istatistikleri veri taşıyıcısı.
class DashboardStats extends Equatable {
  final int totalRequiredDays;
  final int completedDays;
  final double progressRatio;
  final int approvedCount;
  final int pendingCount;
  final int revisionCount;
  final int draftCount;

  const DashboardStats({
    this.totalRequiredDays = 0,
    this.completedDays = 0,
    this.progressRatio = 0.0,
    this.approvedCount = 0,
    this.pendingCount = 0,
    this.revisionCount = 0,
    this.draftCount = 0,
  });

  @override
  List<Object?> get props => [
    totalRequiredDays,
    completedDays,
    progressRatio,
    approvedCount,
    pendingCount,
    revisionCount,
    draftCount,
  ];
}

/// Öğrenci paneli durumları.
sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardNoInternship extends DashboardState {
  const DashboardNoInternship();
}

class DashboardLoaded extends DashboardState {
  final InternshipModel internship;
  final List<DailyReportModel> reports;
  final DashboardStats stats;

  const DashboardLoaded({
    required this.internship,
    required this.reports,
    required this.stats,
  });

  List<DailyReportModel> get recentReports =>
      reports.take(5).toList(growable: false);

  @override
  List<Object?> get props => [internship, reports, stats];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
