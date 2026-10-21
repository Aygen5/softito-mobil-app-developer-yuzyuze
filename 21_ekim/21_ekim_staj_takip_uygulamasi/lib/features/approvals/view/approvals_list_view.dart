import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/approvals_cubit.dart';
import '../cubit/approvals_state.dart';

/// Yetkili inceleme bekleyen raporlar listesi ekranı (Stitch Redesign).
class ApprovalsListView extends StatelessWidget {
  const ApprovalsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        backgroundColor: isDark
            ? const Color(0xFF0B1120)
            : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school_rounded,
                    color: Color(0xFF38BDF8),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isCompany
                      ? 'Kurum İnceleme Bekleyenler'
                      : 'Akademik Onay Bekleyenler',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          actions: const [ThemeToggleButton(), SizedBox(width: 8)],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = reports[index];
                final student = state.students[report.studentId];
                final internship = state.internships[report.internshipId];

                return _PendingReportCard(
                  report: report,
                  isDark: isDark,
                  studentName: student?.fullName ?? 'Aygen Yıldırım',
                  companyName:
                      internship?.companyName ?? 'Aselsan A.Ş. — Ar-Ge',
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
  final bool isDark;
  final String studentName;
  final String companyName;
  final VoidCallback onTap;

  const _PendingReportCard({
    required this.report,
    required this.isDark,
    required this.studentName,
    required this.companyName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF161F30) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF283548)
        : const Color(0xFFE2E8F0);
    final subcardColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFF2563EB),
                            child: Text(
                              studentName.isNotEmpty
                                  ? studentName[0].toUpperCase()
                                  : 'Ö',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  studentName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  companyName,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(
                      status: report.status,
                      size: StatusBadgeSize.small,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormatter.formatDateTurkish(report.workDate),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${report.hoursWorked} Saat',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    if (report.hasAttachments) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.attach_file_rounded,
                        size: 13,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${report.attachmentPaths.length} Belge',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: subcardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    report.tasks,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'İncele ve Onayla',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Color(0xFF2563EB),
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
