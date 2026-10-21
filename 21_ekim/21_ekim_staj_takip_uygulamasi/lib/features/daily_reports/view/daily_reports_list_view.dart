import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_modals.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/daily_reports_cubit.dart';
import '../cubit/daily_reports_state.dart';

/// Ekran 3: Staj Günlüğüm ve Rapor Listesi Görünümü (Stitch Redesign).
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubitState = context.watch<DailyReportsCubit>().state;

    return Scaffold(
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
            Text(
              'Staj Günlüğüm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      floatingActionButton: (cubitState is DailyReportsLoaded)
          ? FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed(
                  RouteNames.studentReportFormName,
                  extra: cubitState.internship.id,
                );
              },
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 3,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Yeni Rapor Ekle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161F30) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF283548)
        : const Color(0xFFE2E8F0);

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
          return const Center(
            child: EmptyView(
              icon: Icons.assignment_outlined,
              title: 'Staj Günlüğü Boş',
              message: 'Stajınız bağlandığında günlük çalışma raporlarınızı buradan listeleyebilir, arayabilir ve yönetebilirsiniz.',
            ),
          );
        }

        if (state is DailyReportsLoaded) {
          final cubit = context.read<DailyReportsCubit>();
          final reports = state.filteredReports;

          return Column(
            children: [
              // Arama ve Filtreleme Başlığı
              Container(
                color: cardColor,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  children: [
                    // Arama Kutusu
                    TextField(
                      controller: _searchController,
                      onChanged: cubit.setSearchQuery,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Raporlarda ara (görev, teknik kazanım)...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: Color(0xFF2563EB),
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
                        fillColor: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Yatay Filtre Çipleri
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Tümü (${state.allReports.length})',
                            isSelected: state.selectedFilter == null,
                            onTap: () => cubit.setFilter(null),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Onaylananlar',
                            isSelected:
                                state.selectedFilter == ReportStatus.approved,
                            onTap: () => cubit.setFilter(ReportStatus.approved),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'İnceleniyor',
                            isSelected:
                                state.selectedFilter == ReportStatus.submitted,
                            onTap: () =>
                                cubit.setFilter(ReportStatus.submitted),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Düzeltme İstenen',
                            isSelected:
                                state.selectedFilter ==
                                ReportStatus.revisionRequested,
                            onTap: () =>
                                cubit.setFilter(ReportStatus.revisionRequested),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Taslaklar',
                            isSelected:
                                state.selectedFilter == ReportStatus.draft,
                            onTap: () => cubit.setFilter(ReportStatus.draft),
                            isDark: isDark,
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
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                          itemCount: reports.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            return _ReportItemCard(
                              report: report,
                              isDark: isDark,
                              onTap: () {
                                // Kullanıcıya modal ile tam rapor detayını açıyoruz
                                AppModals.showReportDetailModal(
                                  context,
                                  report,
                                );
                              },
                              onEdit: () {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A))
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isDark ? const Color(0xFF283548) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ReportItemCard extends StatelessWidget {
  final DailyReportModel report;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _ReportItemCard({
    required this.report,
    required this.isDark,
    required this.onTap,
    required this.onEdit,
    this.onDelete,
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
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${DateFormatter.formatDateTurkish(report.workDate)} • ${report.hoursWorked} Saat',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
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
                const SizedBox(height: 10),
                Text(
                  report.tasks,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                if (report.status == ReportStatus.revisionRequested &&
                    report.revisionComment != null &&
                    report.revisionComment!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF451A1A)
                          : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF7F1D1D)
                            : const Color(0xFFFECACA),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 15,
                          color: isDark
                              ? const Color(0xFFFCA5A5)
                              : const Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            report.revisionComment!,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: subcardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${report.hoursWorked} Saat Çalışma',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                    if (report.hasAttachments) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: subcardColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_file_rounded,
                              size: 13,
                              color: Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${report.attachmentPaths.length} Ek',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (report.status == ReportStatus.draft ||
                        report.status == ReportStatus.revisionRequested)
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text(
                          'Düzenle',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          foregroundColor: const Color(0xFF2563EB),
                        ),
                      )
                    else
                      const Row(
                        children: [
                          Text(
                            'Detayı Gör',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: Color(0xFF2563EB),
                          ),
                        ],
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
