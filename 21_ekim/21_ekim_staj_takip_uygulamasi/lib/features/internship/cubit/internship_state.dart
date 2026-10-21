import 'package:equatable/equatable.dart';

import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';

/// Staj takvimindeki her bir iş gününün durumu.
enum TimelineDayStatus {
  approved,
  submitted,
  revisionRequested,
  draft,
  missing,
  future,
}

/// Zaman çizelgesindeki tek bir iş günü modeli.
class TimelineDay extends Equatable {
  final DateTime date;
  final TimelineDayStatus status;
  final DailyReportModel? report;

  const TimelineDay({required this.date, required this.status, this.report});

  bool get isApproved => status == TimelineDayStatus.approved;
  bool get isMissing => status == TimelineDayStatus.missing;

  @override
  List<Object?> get props => [date, status, report];
}

/// Staj ilerleme ve takvim durumları.
sealed class InternshipState extends Equatable {
  const InternshipState();

  @override
  List<Object?> get props => [];
}

class InternshipInitial extends InternshipState {
  const InternshipInitial();
}

class InternshipLoading extends InternshipState {
  const InternshipLoading();
}

class InternshipNoInternship extends InternshipState {
  const InternshipNoInternship();
}

class InternshipLoaded extends InternshipState {
  final InternshipModel internship;
  final List<DailyReportModel> reports;
  final List<TimelineDay> timelineDays;
  final int missingDaysCount;
  final int approvedDaysCount;
  final int totalWorkdaysCount;
  final double progressRatio;

  const InternshipLoaded({
    required this.internship,
    required this.reports,
    required this.timelineDays,
    required this.missingDaysCount,
    required this.approvedDaysCount,
    required this.totalWorkdaysCount,
    required this.progressRatio,
  });

  @override
  List<Object?> get props => [
    internship,
    reports,
    timelineDays,
    missingDaysCount,
    approvedDaysCount,
    totalWorkdaysCount,
    progressRatio,
  ];
}

class InternshipError extends InternshipState {
  final String message;

  const InternshipError(this.message);

  @override
  List<Object?> get props => [message];
}
