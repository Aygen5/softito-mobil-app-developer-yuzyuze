import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';

/// PDF Staj Defteri Cubit durumları.
sealed class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

final class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

final class DocumentsLoading extends DocumentsState {
  final String? message;
  const DocumentsLoading({this.message});

  @override
  List<Object?> get props => [message];
}

final class DocumentsLoaded extends DocumentsState {
  final UserModel student;
  final InternshipModel internship;
  final List<DailyReportModel> approvedReports;
  final UserModel? advisor;
  final UserModel? companySupervisor;
  final Uint8List pdfBytes;

  const DocumentsLoaded({
    required this.student,
    required this.internship,
    required this.approvedReports,
    this.advisor,
    this.companySupervisor,
    required this.pdfBytes,
  });

  int get totalRequiredDays => internship.requiredDays;
  int get approvedDaysCount => approvedReports.length;
  bool get isFullyCompleted => approvedDaysCount >= totalRequiredDays;
  bool get hasMissingDays => approvedDaysCount < totalRequiredDays;
  int get totalHours =>
      approvedReports.fold<int>(0, (sum, item) => sum + item.hoursWorked);

  @override
  List<Object?> get props => [
    student,
    internship,
    approvedReports,
    advisor,
    companySupervisor,
    pdfBytes,
  ];
}

final class DocumentsFailure extends DocumentsState {
  final String message;
  const DocumentsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
