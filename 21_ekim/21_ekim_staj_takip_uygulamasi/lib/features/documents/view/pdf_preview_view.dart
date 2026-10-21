import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/documents_cubit.dart';
import '../cubit/documents_state.dart';
import '../services/pdf_generator_service.dart';

/// Ekran 6: PDF Staj Defteri Önizleme ve İndirme Ekranı (Stitch Screen 6).
class PdfPreviewView extends StatelessWidget {
  final String internshipId;

  const PdfPreviewView({
    super.key,
    required this.internshipId,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final student = authState.currentUser;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Staj Defteri PDF')),
        body: const Center(
          child: Text('Kullanıcı oturumu bulunamadı.'),
        ),
      );
    }

    return BlocProvider<DocumentsCubit>(
      create: (context) => DocumentsCubit(
        internshipId: internshipId,
        student: student,
        dailyReportRepository: context.read<DailyReportRepository>(),
        internshipRepository: context.read<InternshipRepository>(),
        userRepository: context.read<UserRepository>(),
        pdfGeneratorService: PdfGeneratorService(),
      ),
      child: const _PdfPreviewScaffold(),
    );
  }
}

class _PdfPreviewScaffold extends StatelessWidget {
  const _PdfPreviewScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Staj Defteri PDF',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNavy),
            tooltip: 'Yeniden Derle',
            onPressed: () {
              context.read<DocumentsCubit>().regenerate();
            },
          ),
        ],
      ),
      body: BlocBuilder<DocumentsCubit, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return LoadingView(message: state.message ?? 'PDF hazırlanıyor...');
          }

          if (state is DocumentsFailure) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmptyView(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'PDF Belgesi Üretilemedi',
                      message: state.message,
                    ),
                    const SizedBox(height: 20),
                    AppButton.primary(
                      text: 'Yeniden Dene',
                      icon: Icons.refresh_rounded,
                      onPressed: () {
                        context.read<DocumentsCubit>().regenerate();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DocumentsLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Durum ve Doğrulama Bilgi Kartı
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: state.isFullyCompleted
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.isFullyCompleted
                          ? AppColors.success.withValues(alpha: 0.4)
                          : AppColors.warning.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.isFullyCompleted
                                ? Icons.verified_rounded
                                : Icons.warning_amber_rounded,
                            color: state.isFullyCompleted
                                ? AppColors.success
                                : AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.isFullyCompleted
                                ? 'Staj Eksiksiz Tamamlandı'
                                : 'Eksik veya Onaysız Gün Uyarısı',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: state.isFullyCompleted
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.isFullyCompleted
                            ? 'Zorunlu ${state.totalRequiredDays} staj gününün tamamı çift aşamalı onaylanmış olup resmî defter hazırlandı.'
                            : 'Zorunlu ${state.totalRequiredDays} staj gününden ${state.approvedDaysCount} gün onaylanmıştır. Yalnızca danışman ve kurum onayından geçmiş raporlar deftere dahil edilmiştir.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildChip(
                            icon: Icons.calendar_today_rounded,
                            label:
                                '${state.approvedDaysCount} / ${state.totalRequiredDays} Onaylı Gün',
                          ),
                          const SizedBox(width: 8),
                          _buildChip(
                            icon: Icons.access_time_rounded,
                            label: '${state.totalHours} Saat',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PDF Önizleme ve Yazdırma / Paylaşma Widget'ı
                Expanded(
                  child: PdfPreview(
                    build: (format) => state.pdfBytes,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    allowPrinting: true,
                    allowSharing: true,
                    pdfFileName:
                        'staj_defteri_${state.student.fullName.replaceAll(' ', '_')}.pdf',
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  static Widget _buildChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
