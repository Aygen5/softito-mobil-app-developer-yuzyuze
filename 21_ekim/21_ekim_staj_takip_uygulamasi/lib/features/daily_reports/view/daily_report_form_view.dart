import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/document_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/daily_report_form_cubit.dart';
import '../cubit/daily_report_form_state.dart';

/// Ekran 2: Günlük Kayıt Ekleme ve Düzenleme (Stitch Screen 2 Tasarımına %100 Sadık).
class DailyReportFormView extends StatelessWidget {
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
    String internshipId = 'staj_demo_001';

    if (extra is DailyReportModel) {
      initialReport = extra as DailyReportModel;
      internshipId = initialReport.internshipId;
    } else if (extra is String) {
      internshipId = extra as String;
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
  int _selectedHours = 8;

  @override
  void dispose() {
    _tasksController.dispose();
    _learningsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              onPressed: () => context.pop(),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Günlük Kayıt Ekle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              const ThemeToggleButton(),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 4),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryBlue.withValues(
                    alpha: 0.15,
                  ),
                  child: const Text(
                    'D',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: _buildFormContent(context, state, isDark),
          bottomNavigationBar: _buildStickyBottomBar(context, state, isDark),
        );
      },
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    DailyReportFormState state,
    bool isDark,
  ) {
    if (state is DailyReportFormLoading) {
      return const LoadingView(message: 'Rapor yükleniyor...');
    }

    if (state is! DailyReportFormReady) {
      return const SizedBox.shrink();
    }

    final cubit = context.read<DailyReportFormCubit>();

    if (!_controllersInitialized) {
      _tasksController.text = state.tasks.isNotEmpty ? state.tasks : 'Frontend mobil arayüz bileşenlerinin Material 3 prensiplerine uygun olarak kodlanması tamamlandı. BLoC state management yapısı kullanılarak kimlik doğrulama akışı bağlandı.';
      _learningsController.text = state.learnings.isNotEmpty ? state.learnings : 'StatefulShellRoute ile kalıcı alt navigasyon yapısını kurgulamayı, token yenileme mekanizmasını ve Flutter test araçlarıyla widget testleri yazmayı öğrendim.';
      _selectedHours = state.hoursWorked > 0 ? state.hoursWorked : 8;
      _controllersInitialized = true;
    }

    final revisionNote =
        state.initialReport?.revisionComment ??
        (state.isEditing
            ? 'Yapılan işler bölümünde kullandığınız kütüphaneleri ve mimari kararları lütfen daha detaylı açıklayınız.'
            : null);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Revizyon Talebi Bildirim Kartı (Screenshot 2)
          if (revisionNote != null) ...[
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 4,
                  ),
                  top: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFDBEAFE),
                  ),
                  right: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFDBEAFE),
                  ),
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFDBEAFE),
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primaryBlue,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Revizyon Talebi • Kurum Yetkilisi Notu',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“$revisionNote”',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mühendis: Selin Yılmaz (Tech Lead)',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Dün, 17:45',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 2. Günlük Kayıt & Tarih Kartı (Screenshot 2)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GÜNLÜK KAYIT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormatter.formatDateTurkish(state.workDate),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
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
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '21 / 30 Gün',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.7,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Çalışma Süresi (Segmentli 3'lü Kartlar - Screenshot 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Çalışma Süresi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Text(
                'Zorunlu Alan',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDurationCard(
                  title: '8 Saat',
                  subtitle: 'Tam Gün',
                  isSelected: _selectedHours == 8,
                  isDark: isDark,
                  onTap: () {
                    setState(() => _selectedHours = 8);
                    cubit.updateHours(8);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDurationCard(
                  title: '4 Saat',
                  subtitle: 'Yarım Gün',
                  isSelected: _selectedHours == 4,
                  isDark: isDark,
                  onTap: () {
                    setState(() => _selectedHours = 4);
                    cubit.updateHours(4);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDurationCard(
                  title: 'İzinli',
                  subtitle: 'Raporlu / Tatil',
                  isSelected: _selectedHours == 0,
                  isDark: isDark,
                  onTap: () {
                    setState(() => _selectedHours = 0);
                    cubit.updateHours(0);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Yapılan İşler • Görevler (Karakter Sayacı ile)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.code_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Yapılan İşler • Görevler',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${_tasksController.text.length} / 500',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: TextFormField(
              controller: _tasksController,
              maxLines: 4,
              onChanged: (val) {
                setState(() {});
                cubit.updateTasks(val);
              },
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
                hintText: 'Bugün hangi modülleri kodladınız veya hangi görevleri tamamladınız?',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lütfen revizyon notunda istenen kütüphane ve mimari detayları eklemeyi unutmayın.',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // 5. Öğrenilenler ve Kazanımlar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: AppColors.accentTeal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Öğrenilenler ve Kazanımlar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '${_learningsController.text.length} / 400',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: TextFormField(
              controller: _learningsController,
              maxLines: 4,
              onChanged: (val) {
                setState(() {});
                cubit.updateLearnings(val);
              },
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
                hintText:
                    'Edindiğiniz teknik veya kurumsal tecrübeleri açıklayın...',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 6. Belge veya Dosya Ekle (Screenshot 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.attach_file_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Belge veya Dosya Ekle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'Maks. 10MB',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Yükleme Alanı
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFBFDBFE),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.primaryBlue,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ekran görüntüsü, kod çıktısı veya PDF ekleyin',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'PDF, PNG, JPG veya ZIP (Maksimum 10MB)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Yüklü Dosya Önizleme Kartı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auth_cubit_test_results.pdf',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '1.4 MB • ',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Yüklendi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDurationCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? AppColors.primaryBlue.withValues(alpha: 0.15)
                      : const Color(0xFFEFF6FF))
                : (isDark ? AppColors.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryBlue
                  : (isDark ? AppColors.darkBorder : AppColors.border),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(
    BuildContext context,
    DailyReportFormState state,
    bool isDark,
  ) {
    if (state is! DailyReportFormReady) return const SizedBox.shrink();
    final cubit = context.read<DailyReportFormCubit>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              onPressed: () {
                cubit.updateTasks(_tasksController.text);
                cubit.updateLearnings(_learningsController.text);
                cubit.saveDraft();
              },
              icon: const Icon(Icons.bookmark_outline_rounded, size: 18),
              label: const Text(
                'Taslak Kaydet',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () {
                cubit.updateTasks(_tasksController.text);
                cubit.updateLearnings(_learningsController.text);
                cubit.submitForApproval();
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Onaya Gönder',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
