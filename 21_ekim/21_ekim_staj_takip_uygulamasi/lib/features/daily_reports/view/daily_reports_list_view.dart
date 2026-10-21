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
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/daily_reports_cubit.dart';
import '../cubit/daily_reports_state.dart';

/// Ekran 3: Staj Günlüğüm ve Rapor Listesi Görünümü.
class DailyReportsListView extends StatelessWidget {
  const DailyReportsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = (authState is AuthAuthenticated) ? authState.user : null;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: LoadingView(message: 'Oturum bilgisi yükleniyor...'),
        ),
      );
    }

    return BlocProvider<DailyReportsCubit>(
      create: (context) => DailyReportsCubit(
        studentId: user.uid,
        internshipRepository: context.read<InternshipRepository>(),
        dailyReportRepository: context.read<DailyReportRepository>(),
      ),
      child: const _DailyReportsScaffold(),
    );
  }
}

class _DailyReportsScaffold extends StatelessWidget {
  const _DailyReportsScaffold();

  @override
  Widget build(BuildContext context) {
    final cubitState = context.watch<DailyReportsCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Staj Günlüğüm',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
      ),
      floatingActionButton: (cubitState is DailyReportsLoaded)
          ? FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed(
                  RouteNames.studentReportFormName,
                  extra: cubitState.internship.id,
                );
              },
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni Rapor'),
            )
          : null,
      body: const _DailyReportsBody(),
    );
  }
}

class _DailyReportsBody extends StatefulWidget {
  const _DailyReportsBody();

  @override
  State<_DailyReportsBody> createState() => _DailyReportsBodyState();
}

class _DailyReportsBodyState extends State<_DailyReportsBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyReportsCubit, DailyReportsState>(
      builder: (context, state) {
        if (state is DailyReportsLoading || state is DailyReportsInitial) {
          return const LoadingView(message: 'Raporlar listeleniyor...');
        }

        if (state is DailyReportsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<DailyReportsCubit>().refresh(),
          );
        }

        if (state is DailyReportsNoInternship) {
          return const EmptyView(
            icon: Icons.assignment_outlined,
            title: 'Aktif Staj Kaydı Yok',
            message: 'Rapor oluşturmak için aktif bir staj kaydı gereklidir.',
          );
        }

        if (state is DailyReportsLoaded) {
          final cubit = context.read<DailyReportsCubit>();
          final reports = state.filteredReports;

          return Column(
            children: [
              // Arama ve Filtreleme Başlığı
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    // Arama Inputu
                    TextField(
                      controller: _searchController,
                      onChanged: cubit.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Raporlarda ara (görev, kazanım)...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  cubit.setSearchQuery('');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Yatay Filtre Çipleri
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Tümü (${state.allReports.length})',
                            isSelected: state.selectedFilter == null,
                            onTap: () => cubit.setFilter(null),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Onaylananlar',
                            isSelected:
                                state.selectedFilter == ReportStatus.approved,
                            onTap: () => cubit.setFilter(ReportStatus.approved),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'İnceleniyor',
                            isSelected:
                                state.selectedFilter == ReportStatus.submitted,
                            onTap: () =>
                                cubit.setFilter(ReportStatus.submitted),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Düzeltme İstenen',
                            isSelected:
                                state.selectedFilter ==
                                ReportStatus.revisionRequested,
                            onTap: () =>
                                cubit.setFilter(ReportStatus.revisionRequested),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Taslaklar',
                            isSelected:
                                state.selectedFilter == ReportStatus.draft,
                            onTap: () => cubit.setFilter(ReportStatus.draft),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Raporlar Listesi veya Boş Görünüm
              Expanded(
                child: reports.isEmpty
                    ? RefreshIndicator(
                        onRefresh: () => cubit.refresh(),
                        child: ListView(
                          children: [
                            const SizedBox(height: 60),
                            EmptyView(
                              icon: Icons.filter_list_off_rounded,
                              title: 'Rapor Bulunamadı',
                              message:
                                  state.searchQuery.isNotEmpty ||
                                      state.selectedFilter != null
                                  ? 'Arama veya filtre kriterlerinize uygun rapor bulunamadı.'
                                  : 'Henüz bir staj raporu oluşturmadınız.',
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => cubit.refresh(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount: reports.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            return _ReportItemCard(
                              report: report,
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.studentReportFormName,
                                  extra: report,
                                );
                              },
                              onDelete: report.status == ReportStatus.draft
                                  ? () => _confirmDelete(context, report)
                                  : null,
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _confirmDelete(BuildContext context, DailyReportModel report) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Taslak Raporu Sil'),
          content: Text(
            '${DateFormatter.formatDateTurkish(report.workDate)} tarihli taslak raporu kalıcı olarak silmek istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DailyReportsCubit>().deleteReport(report.id);
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNavy : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryNavy : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ReportItemCard extends StatelessWidget {
  final DailyReportModel report;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _ReportItemCard({
    required this.report,
    required this.onTap,
    this.onDelete,
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
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.formatDateTurkish(report.workDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        StatusBadge(status: report.status),
                        if (onDelete != null) ...[
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: AppColors.error,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (report.status == ReportStatus.revisionRequested &&
                    report.revisionComment != null &&
                    report.revisionComment!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Düzeltme Talebi: ${report.revisionComment}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  report.tasks,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${report.hoursWorked} Çalışma Saati',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (report.hasAttachments) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_file_rounded,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${report.attachmentPaths.length} Ek',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
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
