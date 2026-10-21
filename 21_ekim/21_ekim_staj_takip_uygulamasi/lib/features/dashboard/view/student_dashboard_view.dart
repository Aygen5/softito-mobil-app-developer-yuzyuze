import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/progress_card.dart';
import '../../../common/widgets/section_header.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_report_card.dart';
import '../widgets/stat_counter_card.dart';

/// Ekran 2: Öğrenci Ana Paneli Görünümü (Stitch Screen 2).
class StudentDashboardView extends StatelessWidget {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = (authState is AuthAuthenticated) ? authState.user : null;

    if (user == null) {
      return const Scaffold(
        body: Center(child: LoadingView(message: 'Oturum bilgisi yükleniyor...')),
      );
    }

    return BlocProvider<DashboardCubit>(
      create: (context) => DashboardCubit(
        studentId: user.uid,
        internshipRepository: context.read<InternshipRepository>(),
        dailyReportRepository: context.read<DailyReportRepository>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleSpacing: 20,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merhaba, ${user.fullName.split(' ').first}',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                DateFormatter.formatDateTurkish(DateTime.now()),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bildirimler yakında eklenecektir.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: const _DashboardBody(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const LoadingView(message: 'Staj bilgileri yükleniyor...');
        }

        if (state is DashboardError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<DashboardCubit>().refresh(),
          );
        }

        if (state is DashboardNoInternship) {
          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 40),
                const EmptyView(
                  icon: Icons.assignment_outlined,
                  title: 'Aktif Staj Kaydı Bulunamadı',
                  message:
                      'Henüz adınıza tanımlanmış aktif bir staj kaydı bulunmuyor. Danışmanınız veya kurum yetkiliniz ile iletişime geçiniz.',
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          final stats = state.stats;
          final internship = state.internship;
          final recentReports = state.recentReports;

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Kurum Adı ve Tarih Aralığı Etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                internship.companyName,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${DateFormatter.formatDateTurkish(internship.startDate)} — ${DateFormatter.formatDateTurkish(internship.endDate)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Staj İlerleme Kartı (Screen 2 Odak Bileşeni)
                  ProgressCard(
                    title: 'Staj İlerleme Durumu',
                    completedDays: stats.completedDays,
                    requiredDays: stats.totalRequiredDays,
                    progressRatio: stats.progressRatio,
                    subtitle:
                        'Onaylanan ${stats.completedDays} / ${stats.totalRequiredDays} zorunlu gün',
                  ),

                  const SizedBox(height: 16),

                  // Durum Sayaçları (2x2 Grid)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: [
                      StatCounterCard(
                        label: 'Onaylanan',
                        count: stats.approvedCount,
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                      ),
                      StatCounterCard(
                        label: 'İnceleniyor',
                        count: stats.pendingCount,
                        icon: Icons.hourglass_top_rounded,
                        color: AppColors.primaryBlue,
                      ),
                      StatCounterCard(
                        label: 'Düzeltme İstenen',
                        count: stats.revisionCount,
                        icon: Icons.error_outline_rounded,
                        color: AppColors.warning,
                      ),
                      StatCounterCard(
                        label: 'Taslak',
                        count: stats.draftCount,
                        icon: Icons.edit_note_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Hızlı Rapor Ekle Butonu
                  AppButton.primary(
                    text: 'Yeni Günlük Rapor Ekle',
                    icon: Icons.add_circle_outline_rounded,
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.studentReportFormName,
                        extra: internship.id,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Son Raporlarım Bölüm Başlığı
                  SectionHeader(
                    title: 'Son Raporlarım',
                    actionLabel:
                        recentReports.isNotEmpty ? 'Tümünü Gör' : null,
                    onActionPressed: recentReports.isNotEmpty
                        ? () {
                            context.go(RouteNames.studentJournal);
                          }
                        : null,
                  ),

                  const SizedBox(height: 12),

                  // Son Raporlar Listesi veya Boş Durum
                  if (recentReports.isEmpty)
                    EmptyView(
                      icon: Icons.note_alt_outlined,
                      title: 'Henüz Rapor Eklenmedi',
                      message:
                          'Bugünün staj çalışmalarını kaydetmek için yukarıdaki butondan ilk raporunuzu ekleyin.',
                    )
                  else
                    ...recentReports.map(
                      (report) => DashboardReportCard(
                        report: report,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.studentReportFormName,
                            extra: report,
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
