import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/daily_report_model.dart';
import 'app_button.dart';

/// Uygulama genelinde kullanılan Stitch standartlarında modern alt çekmece (Bottom Sheet) ve modal pencereler.
abstract final class AppModals {
  /// Haftalık raporlama rehberi ve ipucu alt penceresi.
  static Future<void> showWeeklyTipModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Haftalık Rapor İpucu',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Staj defterinizi düzenli ve eksiksiz tutun',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    _buildTipStep(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'Günlük Kayıt Disiplini',
                      desc: 'Her iş günü sonunda görevlerinizi ve teknik kazanımlarınızı kaydedin.',
                      isDark: isDark,
                    ),
                    const Divider(height: 20),
                    _buildTipStep(
                      icon: Icons.draw_outlined,
                      title: 'Haftalık Toplu İmza Kolaylığı',
                      desc: 'Cuma günleri mesai bitiminde haftanın 5 gününü mentorünüze tek seferde onaylatabilirsiniz.',
                      isDark: isDark,
                    ),
                    const Divider(height: 20),
                    _buildTipStep(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'Otomatik PDF Defter',
                      desc: 'Onaylanan tüm günler resmî staj defteri formatında anında PDF çıktısına dönüşür.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Anladım',
                onPressed: () => Navigator.of(modalContext).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTipStep({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.accentTeal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Rapor Detaylarını Stitch Ekran 5 standartlarında açan modern alt çekmece.
  static Future<void> showReportDetailModal(
    BuildContext context,
    DailyReportModel report,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Sürükleme Tutamacı
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Modal Başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kayıt Detayı',
                          style: AppTextStyles.h2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(modalContext).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // İçerik
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Resmi Kurum Onay Protokolü Banner
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 16,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Resmi Kurum Onay Protokolü',
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'GÜN 20 / 30',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Onay Süreç Çizelgesi (4 Adım)
                        _buildStepper(isDark: isDark, status: report.status),
                        const SizedBox(height: 20),

                        // Rapor İçerik Kartı
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormatter.formatDateTurkish(
                                      report.workDate,
                                    ),
                                    style: AppTextStyles.h3.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkSurfaceVariant
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${report.hoursWorked} Saat Mesai',
                                      style: AppTextStyles.caption.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Yapılan İşler & Görevler',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                report.tasks,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Kazanımlar & Teknik Gelişim',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentTeal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                report.learnings,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Revizyon Notu Varsa
                        if (report.revisionComment != null &&
                            report.revisionComment!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.08),
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
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kurum Yetkilisi Revizyon Talebi',
                                        style: AppTextStyles.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        report.revisionComment!,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildStepper({
    required bool isDark,
    required ReportStatus status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ONAY SÜREÇ ÇİZELGESİ',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.isApproved ? 'Tamamlandı' : 'İnceleme Aktif',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: status.isApproved
                        ? AppColors.accentTeal
                        : AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildStepItem(
                icon: Icons.person_rounded,
                title: 'Öğrenci',
                isDone: true,
              ),
              Expanded(
                child: Container(height: 2, color: AppColors.accentTeal),
              ),
              _buildStepItem(
                icon: Icons.business_rounded,
                title: 'Kurum',
                isDone: status.isApproved || status.isSubmitted,
                isActive: status.isSubmitted,
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: status.isApproved
                      ? AppColors.accentTeal
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                ),
              ),
              _buildStepItem(
                icon: Icons.school_rounded,
                title: 'Akademik',
                isDone: status.isApproved,
                isActive: status.isApproved,
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: status.isApproved
                      ? AppColors.accentTeal
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                ),
              ),
              _buildStepItem(
                icon: Icons.verified_rounded,
                title: 'Nihai Onay',
                isDone: status.isApproved,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildStepItem({
    required IconData icon,
    required String title,
    bool isDone = false,
    bool isActive = false,
  }) {
    Color bg = AppColors.border;
    Color fg = AppColors.textSecondary;

    if (isDone) {
      bg = AppColors.accentTeal;
      fg = Colors.white;
    } else if (isActive) {
      bg = AppColors.primaryBlue;
      fg = Colors.white;
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: fg),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
