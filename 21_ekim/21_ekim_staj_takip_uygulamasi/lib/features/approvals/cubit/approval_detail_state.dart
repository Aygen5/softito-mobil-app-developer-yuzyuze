import 'package:equatable/equatable.dart';

import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/user_model.dart';

/// Rapor onay ve puanlama ekranı durumları.
sealed class ApprovalDetailState extends Equatable {
  const ApprovalDetailState();

  @override
  List<Object?> get props => [];
}

class ApprovalDetailInitial extends ApprovalDetailState {
  const ApprovalDetailInitial();
}

class ApprovalDetailLoading extends ApprovalDetailState {
  final String message;

  const ApprovalDetailLoading({this.message = 'Rapor detayları yükleniyor...'});

  @override
  List<Object?> get props => [message];
}

class ApprovalDetailLoaded extends ApprovalDetailState {
  final DailyReportModel report;
  final InternshipModel? internship;
  final UserModel? student;
  final List<ReviewModel> reviews;
  final bool isSubmitting;

  const ApprovalDetailLoaded({
    required this.report,
    this.internship,
    this.student,
    required this.reviews,
    this.isSubmitting = false,
  });

  ApprovalDetailLoaded copyWith({
    DailyReportModel? report,
    InternshipModel? internship,
    UserModel? student,
    List<ReviewModel>? reviews,
    bool? isSubmitting,
  }) {
    return ApprovalDetailLoaded(
      report: report ?? this.report,
      internship: internship ?? this.internship,
      student: student ?? this.student,
      reviews: reviews ?? this.reviews,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
    report,
    internship,
    student,
    reviews,
    isSubmitting,
  ];
}

class ApprovalDetailSuccess extends ApprovalDetailState {
  final String message;
  final bool isApproved;

  const ApprovalDetailSuccess({
    required this.message,
    required this.isApproved,
  });

  @override
  List<Object?> get props => [message, isApproved];
}

class ApprovalDetailFailure extends ApprovalDetailState {
  final String message;

  const ApprovalDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
