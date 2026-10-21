import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/progress_card.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/internship_cubit.dart';
import '../cubit/internship_state.dart';

/// Ekran 5: İlerleme, Geçmiş ve Eksik Gün Motoru (Stitch Screen 5).
class InternshipProgressView extends StatelessWidget {
  const InternshipProgressView({super.key});

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

    return BlocProvider<InternshipCubit>(
      create: (context) => InternshipCubit(
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
          title: Text(
            'Staj İlerlemem & Takvim',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const _ProgressBody(),
      ),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternshipCubit, InternshipState>(
      builder: (context, state) {
        if (state is InternshipLoading || state is InternshipInitial) {
          return const LoadingView(message: 'İlerleme takvimi hesaplanıyor...');
        }

        if (state is InternshipError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<InternshipCubit>().refresh(),
          );
        }

        if (state is InternshipNoInternship) {
          return const EmptyView(
            icon: Icons.calendar_today_outlined,
            title: 'Aktif Staj Bulunamadı',
            message: 'Staj ilerleme ve eksik gün takibi için aktif bir staj kaydınız olmalıdır.',
          );
        }

        if (state is InternshipLoaded) {
          final internship = state.internship;
          final timelineDays = state.timelineDays;

          return RefreshIndicator(
            onRefresh: () => context.read<InternshipCubit>().refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // İlerleme Kartı
                  ProgressCard(
                    title: 'Tamamlanan Günler',
                    completedDays: state.approvedDaysCount,
                    requiredDays: internship.requiredDays,
                    progressRatio: state.progressRatio,
                    subtitle:
                        'Onaylanan ${state.approvedDaysCount} / ${internship.requiredDays} gün',
                  ),

                  const SizedBox(height: 16),

                  // Eksik Gün Motoru Durum Bildirimi
                  if (state.missingDaysCount > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.missingDaysCount} Eksik Gün Tespit Edildi',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Geçmiş iş günlerinize ait rapor girişi yapılmamıştır. Lütfen aşağıdaki listeden eksik günleri seçerek raporlarınızı tamamlayınız.',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Eksiksiz İlerleme: Geçmiş tüm çalışma günlerine ait raporlarınız kaydedilmiştir.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Staj Defteri PDF Görüntüleme & İndirme Butonu (Ekran 6)
                  AppButton.outline(
                    text: 'Resmî Staj Defteri PDF Görüntüle & İndir',
                    icon: Icons.picture_as_pdf_outlined,
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.studentPdfPreviewName,
                        extra: internship.id,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Zaman Çizelgesi Başlığı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'İş Günü Geçmişi (${timelineDays.length} Gün)',
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hafta sonları hariç',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Zaman Çizelgesi Listesi
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timelineDays.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final day = timelineDays[index];
                      return _TimelineDayTile(
                        day: day,
                        internshipId: internship.id,
                      );
                    },
                  ),

                  const SizedBox(height: 32),
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

class _TimelineDayTile extends StatelessWidget {
  final TimelineDay day;
  final String internshipId;

  const _TimelineDayTile({required this.day, required this.internshipId});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (day.status) {
      case TimelineDayStatus.approved:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Onaylandı';
        break;
      case TimelineDayStatus.submitted:
        statusColor = AppColors.primaryBlue;
        statusIcon = Icons.hourglass_top_rounded;
        statusText = 'İnceleniyor';
        break;
      case TimelineDayStatus.revisionRequested:
        statusColor = AppColors.warning;
        statusIcon = Icons.warning_amber_rounded;
        statusText = 'Düzeltme İstenen';
        break;
      case TimelineDayStatus.draft:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.edit_note_rounded;
        statusText = 'Taslak';
        break;
      case TimelineDayStatus.missing:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_outlined;
        statusText = 'Eksik Rapor';
        break;
      case TimelineDayStatus.future:
        statusColor = AppColors.border;
        statusIcon = Icons.radio_button_unchecked_rounded;
        statusText = 'Planlandı';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: day.isMissing
              ? AppColors.error.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (day.report != null) {
              context.pushNamed(
                RouteNames.studentReportFormName,
                extra: day.report,
              );
            } else if (day.status == TimelineDayStatus.missing) {
              // Eksik gün için yeni rapor formu aç
              context.pushNamed(
                RouteNames.studentReportFormName,
                extra: internshipId,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatter.formatDateTurkish(day.date),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (day.report != null)
                        Text(
                          day.report!.tasks,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      else if (day.isMissing)
                        Text(
                          'Rapor oluşturmak için dokunun',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
