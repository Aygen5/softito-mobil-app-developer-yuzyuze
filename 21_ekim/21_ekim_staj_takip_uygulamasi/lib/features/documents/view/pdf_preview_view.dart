import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/theme_toggle_button.dart';
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

  const PdfPreviewView({super.key, required this.internshipId});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final student = authState.currentUser;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Staj Defteri PDF')),
        body: const Center(child: Text('Kullanıcı oturumu bulunamadı.')),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF161F30) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF283548) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          onPressed: () => context.pop(),
        ),
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
              'Staj Defteri PDF',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
            ),
            tooltip: 'Yeniden Derle',
            onPressed: () {
              context.read<DocumentsCubit>().regenerate();
            },
          ),
          const SizedBox(width: 8),
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
                // Durum ve Doğrulama Bilgi Kartı (Light & Dark mode uyumlu)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: state.isFullyCompleted
                        ? (isDark
                            ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                            : const Color(0xFFECFDF5))
                        : (isDark
                            ? const Color(0xFF451A1A).withValues(alpha: 0.45)
                            : const Color(0xFFFFFBEB)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.isFullyCompleted
                          ? (isDark
                              ? const Color(0xFF065F46)
                              : const Color(0xFFA7F3D0))
                          : (isDark
                              ? const Color(0xFF7F1D1D)
                              : const Color(0xFFFDE68A)),
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
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF59E0B),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.isFullyCompleted
                                ? 'Staj Eksiksiz Tamamlandı'
                                : 'Eksik veya Onaysız Gün Uyarısı',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: state.isFullyCompleted
                                  ? (isDark
                                      ? const Color(0xFF6EE7B7)
                                      : const Color(0xFF065F46))
                                  : (isDark
                                      ? const Color(0xFFFCD34D)
                                      : const Color(0xFF92400E)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.isFullyCompleted
                            ? 'Zorunlu ${state.totalRequiredDays} staj gününün tamamı çift aşamalı onaylanmış olup resmî defter hazırlandı.'
                            : 'Zorunlu ${state.totalRequiredDays} staj gününden ${state.approvedDaysCount} gün onaylanmıştır. Yalnızca danışman ve kurum onayından geçmiş raporlar deftere dahil edilmiştir.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildChip(
                            icon: Icons.calendar_today_rounded,
                            label:
                                '${state.approvedDaysCount} / ${state.totalRequiredDays} Onaylı Gün',
                            isDark: isDark,
                            cardColor: cardColor,
                            borderColor: borderColor,
                          ),
                          const SizedBox(width: 8),
                          _buildChip(
                            icon: Icons.access_time_rounded,
                            label: '${state.totalHours} Saat',
                            isDark: isDark,
                            cardColor: cardColor,
                            borderColor: borderColor,
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
                    scrollViewDecoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1120)
                          : const Color(0xFFF1F5F9),
                    ),
                    pdfPreviewPageDecoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.4 : 0.08,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    pdfFileName:
                        'staj_defteri_${state.student.fullName.replaceAll(' ', '_')}.pdf',
                    loadingWidget: Center(
                      child: CircularProgressIndicator(
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF2563EB),
                      ),
                    ),
                    onError: (context, error) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 48,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'PDF Belgeniz Başarıyla Oluşturuldu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Aşağıdaki butonları kullanarak PDF staj defterinizi doğrudan yazdırabilir veya kaydedebilirsiniz.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Printing.sharePdf(
                                    bytes: state.pdfBytes,
                                    filename:
                                        'staj_defteri_${state.student.fullName.replaceAll(' ', '_')}.pdf',
                                  );
                                },
                                icon: const Icon(Icons.share_rounded, size: 18),
                                label: const Text('PDF İndir / Paylaş'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2563EB)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
