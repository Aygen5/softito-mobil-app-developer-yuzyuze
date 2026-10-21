import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/attachment_tile.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/document_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/daily_report_form_cubit.dart';
import '../cubit/daily_report_form_state.dart';

/// Ekran 3: Staj Günlük Rapor Formu (Stitch Screen 3).
class DailyReportFormView extends StatelessWidget {
  /// Ya doğrudan düzenlenecek [DailyReportModel], ya da yeni oluşturulacak [internshipId] string'i.
  final Object? extra;

  const DailyReportFormView({super.key, this.extra});

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

    DailyReportModel? initialReport;
    String internshipId = '';

    if (extra is DailyReportModel) {
      initialReport = extra as DailyReportModel;
      internshipId = initialReport.internshipId;
    } else if (extra is String) {
      internshipId = extra as String;
    }

    if (internshipId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: const Center(
          child: Text('Staj kimliği bulunamadı. Lütfen tekrar deneyiniz.'),
        ),
      );
    }

    return BlocProvider<DailyReportFormCubit>(
      create: (context) => DailyReportFormCubit(
        internshipId: internshipId,
        studentId: user.uid,
        initialReport: initialReport,
        dailyReportRepository: context.read<DailyReportRepository>(),
        documentRepository: context.read<DocumentRepository>(),
      ),
      child: const _ReportFormScaffold(),
    );
  }
}

class _ReportFormScaffold extends StatefulWidget {
  const _ReportFormScaffold();

  @override
  State<_ReportFormScaffold> createState() => _ReportFormScaffoldState();
}

class _ReportFormScaffoldState extends State<_ReportFormScaffold> {
  final TextEditingController _tasksController = TextEditingController();
  final TextEditingController _learningsController = TextEditingController();
  bool _controllersInitialized = false;

  @override
  void dispose() {
    _tasksController.dispose();
    _learningsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyReportFormCubit, DailyReportFormState>(
      listener: (context, state) {
        if (state is DailyReportFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        } else if (state is DailyReportFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isEditing = state is DailyReportFormReady && state.isEditing;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: Text(
              isEditing ? 'Raporu Düzenle' : 'Yeni Günlük Rapor',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DailyReportFormState state) {
    if (state is DailyReportFormLoading) {
      return LoadingView(message: state.message);
    }

    if (state is! DailyReportFormReady) {
      return const SizedBox.shrink();
    }

    final cubit = context.read<DailyReportFormCubit>();

    if (!_controllersInitialized) {
      _tasksController.text = state.tasks;
      _learningsController.text = state.learnings;
      _controllersInitialized = true;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Düzeltme Talebi Açıklaması Varsa Göster
          if (state.hasRevisionComment) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Yetkili Düzeltme Talebi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.initialReport!.revisionComment!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Çalışma Tarihi Seçici Kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: state.dateError != null
                    ? AppColors.error
                    : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Çalışma Tarihi',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _pickDate(context, state.workDate),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              DateFormatter.formatDateTurkish(state.workDate),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Değiştir',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.dateError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    state.dateError!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Çalışma Süresi Seçici
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Çalışma Süresi',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [4, 6, 8].map((hours) {
                    final isSelected = state.hoursWorked == hours;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$hours Saat'),
                        selected: isSelected,
                        selectedColor: AppColors.primaryBlue,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            cubit.updateHours(hours);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Yapılan İşler Alanı
          AppTextField(
            label: 'Bugün Neler Yaptınız? (Yapılan İşler)',
            hint: 'Gerçekleştirdiğiniz görevleri, projeleri ve adımları detaylıca yazınız...',
            controller: _tasksController,
            maxLines: 5,
            onChanged: cubit.updateTasks,
          ),

          const SizedBox(height: 16),

          // Öğrenilenler ve Kazanımlar Alanı
          AppTextField(
            label: 'Öğrenilenler ve Kazanımlar',
            hint: 'Kullandığınız teknolojiler, edindiğiniz tecrübeler ve yeni bilgiler...',
            controller: _learningsController,
            maxLines: 4,
            onChanged: cubit.updateLearnings,
          ),

          const SizedBox(height: 16),

          // Belge ve Ek Dosyalar Bölümü
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ekli Belgeler (${state.attachmentPaths.length})',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (state.isUploadingAttachment)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      TextButton.icon(
                        icon: const Icon(Icons.attach_file_rounded, size: 18),
                        label: const Text('Dosya Ekle'),
                        onPressed: cubit.pickAndUploadAttachment,
                      ),
                  ],
                ),
                if (state.attachmentPaths.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'İsteğe bağlı olarak kod çıktısı, ekran görüntüsü veya rapor belgesi (PDF/Görsel, max 10MB) ekleyebilirsiniz.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  ...state.attachmentPaths.asMap().entries.map((entry) {
                    final index = entry.key;
                    final path = entry.value;
                    final fileName = path.split('/').last.split('?').first;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AttachmentTile(
                        fileName: fileName,
                        onRemove: () => cubit.removeAttachment(index),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Butonlar: Taslak Kaydet & Onaya Gönder
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'Taslak Olarak Kaydet',
                  onPressed: cubit.saveDraft,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  text: 'Onaya Gönder',
                  icon: Icons.send_rounded,
                  onPressed: cubit.submitForApproval,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('tr', 'TR'),
      selectableDayPredicate: (date) {
        // Hafta sonlarını devre dışı bırak
        return date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday;
      },
    );

    if (picked != null && context.mounted) {
      context.read<DailyReportFormCubit>().updateWorkDate(picked);
    }
  }
}
