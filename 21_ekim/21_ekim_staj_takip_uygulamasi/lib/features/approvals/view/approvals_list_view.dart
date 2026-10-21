import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/approvals_cubit.dart';
import '../cubit/approvals_state.dart';

/// Yetkili inceleme bekleyen raporlar listesi ekranı.
class ApprovalsListView extends StatelessWidget {
  const ApprovalsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: LoadingView(message: 'Oturum yükleniyor...')),
      );
    }

    final isCompany = user.role.isCompany;

    return BlocProvider<ApprovalsCubit>(
      create: (context) => ApprovalsCubit(
        reviewerId: user.uid,
        reviewerRole: user.role,
        internshipRepository: context.read<InternshipRepository>(),
        dailyReportRepository: context.read<DailyReportRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          title: Text(
            isCompany
                ? 'Kurum İnceleme Bekleyenler'
                : 'Akademik Onay Bekleyenler',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const _ApprovalsListBody(),
      ),
    );
  }
}

class _ApprovalsListBody extends StatelessWidget {
  const _ApprovalsListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovalsCubit, ApprovalsState>(
      builder: (context, state) {
        if (state is ApprovalsLoading || state is ApprovalsInitial) {
          return const LoadingView(
            message: 'İnceleme bekleyen raporlar getiriliyor...',
          );
        }

        if (state is ApprovalsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<ApprovalsCubit>().refresh(),
          );
        }

        if (state is ApprovalsEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<ApprovalsCubit>().refresh(),
            child: ListView(
              children: [
                const SizedBox(height: 60),
                EmptyView(
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Bekleyen Rapor Yok',
                  message: state.message,
                ),
              ],
            ),
          );
        }

        if (state is ApprovalsLoaded) {
          final reports = state.pendingReports;
          final cubit = context.read<ApprovalsCubit>();

          return RefreshIndicator(
            onRefresh: () => cubit.refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = reports[index];
                final student = state.students[report.studentId];
                final internship = state.internships[report.internshipId];

                return _PendingReportCard(
                  report: report,
                  studentName: student?.fullName ?? 'Öğrenci',
                  companyName: internship?.companyName ?? 'Staj Kurumu',
                  onTap: () async {
                    await context.pushNamed(
                      RouteNames.approvalDetailName,
                      extra: report,
                    );
                    cubit.refresh();
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _PendingReportCard extends StatelessWidget {
  final DailyReportModel report;
  final String studentName;
  final String companyName;
  final VoidCallback onTap;

  const _PendingReportCard({
    required this.report,
    required this.studentName,
    required this.companyName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            companyName,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: report.status, size: StatusBadgeSize.small),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormatter.formatDateTurkish(report.workDate),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${report.hoursWorked} Saat',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (report.hasAttachments) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.attach_file_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${report.attachmentPaths.length} Belge',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  report.tasks,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Raporu İncele',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
