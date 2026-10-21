import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failure.dart';
import '../../../core/utils/workday_calculator.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'supervised_interns_state.dart';

/// Yetkiliye atanmış stajyerlerin/öğrencilerin ilerlemelerini yöneten Cubit.
class SupervisedInternsCubit extends Cubit<SupervisedInternsState> {
  final String reviewerId;
  final UserRole reviewerRole;
  final InternshipRepository internshipRepository;
  final DailyReportRepository dailyReportRepository;
  final UserRepository userRepository;

  SupervisedInternsCubit({
    required this.reviewerId,
    required this.reviewerRole,
    required this.internshipRepository,
    required this.dailyReportRepository,
    required this.userRepository,
  }) : super(const SupervisedInternsInitial()) {
    loadInterns();
  }

  Future<void> loadInterns() async {
    emit(const SupervisedInternsLoading());

    try {
      final List<InternshipModel> internships;
      if (reviewerRole.isCompany) {
        internships = await internshipRepository.getInternshipsForSupervisor(
          reviewerId,
        );
      } else {
        internships = await internshipRepository.getInternshipsForAdvisor(
          reviewerId,
        );
      }

      if (internships.isEmpty) {
        emit(const SupervisedInternsEmpty());
        return;
      }

      final items = <InternProgressItem>[];
      for (final internship in internships) {
        final student = await userRepository.getUserProfile(
          internship.studentId,
        );
        if (student != null) {
          final approvedReports = await dailyReportRepository
              .getApprovedReports(internship.id);
          final progressRatio = WorkdayCalculator.calculateProgressRatio(
            completedDays: approvedReports.length,
            requiredDays: internship.requiredDays,
          );

          items.add(
            InternProgressItem(
              internship: internship,
              student: student,
              approvedDays: approvedReports.length,
              progressRatio: progressRatio,
            ),
          );
        }
      }

      if (items.isEmpty) {
        emit(const SupervisedInternsEmpty());
      } else {
        emit(SupervisedInternsLoaded(items));
      }
    } on Failure catch (e) {
      emit(SupervisedInternsError(e.message));
    } catch (e) {
      emit(SupervisedInternsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadInterns();
  }
}
