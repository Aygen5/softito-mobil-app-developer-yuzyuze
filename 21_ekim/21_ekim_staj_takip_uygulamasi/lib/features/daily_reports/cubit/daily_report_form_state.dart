import 'package:equatable/equatable.dart';
import '../../../data/models/daily_report_model.dart';

/// Rapor formu durumları.
sealed class DailyReportFormState extends Equatable {
  const DailyReportFormState();

  @override
  List<Object?> get props => [];
}

class DailyReportFormInitial extends DailyReportFormState {
  const DailyReportFormInitial();
}

class DailyReportFormLoading extends DailyReportFormState {
  final String message;

  const DailyReportFormLoading({this.message = 'İşlem yapılıyor...'});

  @override
  List<Object?> get props => [message];
}

class DailyReportFormReady extends DailyReportFormState {
  final DateTime workDate;
  final int hoursWorked;
  final String tasks;
  final String learnings;
  final List<String> attachmentPaths;
  final DailyReportModel? initialReport;
  final bool isUploadingAttachment;
  final String? dateError;

  const DailyReportFormReady({
    required this.workDate,
    required this.hoursWorked,
    required this.tasks,
    required this.learnings,
    required this.attachmentPaths,
    this.initialReport,
    this.isUploadingAttachment = false,
    this.dateError,
  });

  DailyReportFormReady copyWith({
    DateTime? workDate,
    int? hoursWorked,
    String? tasks,
    String? learnings,
    List<String>? attachmentPaths,
    DailyReportModel? initialReport,
    bool? isUploadingAttachment,
    String? Function()? dateError,
  }) {
    return DailyReportFormReady(
      workDate: workDate ?? this.workDate,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      tasks: tasks ?? this.tasks,
      learnings: learnings ?? this.learnings,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
      initialReport: initialReport ?? this.initialReport,
      isUploadingAttachment:
          isUploadingAttachment ?? this.isUploadingAttachment,
      dateError: dateError != null ? dateError() : this.dateError,
    );
  }

  bool get isEditing => initialReport != null;
  bool get hasRevisionComment =>
      initialReport?.revisionComment != null &&
      initialReport!.revisionComment!.isNotEmpty;

  @override
  List<Object?> get props => [
    workDate,
    hoursWorked,
    tasks,
    learnings,
    attachmentPaths,
    initialReport,
    isUploadingAttachment,
    dateError,
  ];
}

class DailyReportFormSuccess extends DailyReportFormState {
  final String message;
  final bool wasSubmitted;

  const DailyReportFormSuccess({
    required this.message,
    required this.wasSubmitted,
  });

  @override
  List<Object?> get props => [message, wasSubmitted];
}

class DailyReportFormFailure extends DailyReportFormState {
  final String message;

  const DailyReportFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
