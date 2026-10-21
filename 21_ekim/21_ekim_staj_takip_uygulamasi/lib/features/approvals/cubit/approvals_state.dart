import 'package:equatable/equatable.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';

/// Yetkili inceleme bekleyen raporlar listesi durumları.
sealed class ApprovalsState extends Equatable {
  const ApprovalsState();

  @override
  List<Object?> get props => [];
}

class ApprovalsInitial extends ApprovalsState {
  const ApprovalsInitial();
}

class ApprovalsLoading extends ApprovalsState {
  const ApprovalsLoading();
}

class ApprovalsLoaded extends ApprovalsState {
  final List<DailyReportModel> pendingReports;
  final Map<String, InternshipModel> internships;
  final Map<String, UserModel> students;
  final int totalInternsCount;

  const ApprovalsLoaded({
    required this.pendingReports,
    required this.internships,
    required this.students,
    required this.totalInternsCount,
  });

  @override
  List<Object?> get props => [
    pendingReports,
    internships,
    students,
    totalInternsCount,
  ];
}

class ApprovalsEmpty extends ApprovalsState {
  final String message;
  final int totalInternsCount;

  const ApprovalsEmpty({
    this.message = 'İnceleme bekleyen yeni bir rapor bulunmamaktadır.',
    this.totalInternsCount = 0,
  });

  @override
  List<Object?> get props => [message, totalInternsCount];
}

class ApprovalsError extends ApprovalsState {
  final String message;

  const ApprovalsError(this.message);

  @override
  List<Object?> get props => [message];
}
