import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/attachment_tile.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/status_badge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/approval_detail_cubit.dart';
import '../cubit/approval_detail_state.dart';

/// Ekran 4: Onay ve Puanlama Arayüzü (Stitch Screen 4).
class ApprovalDetailView extends StatelessWidget {
  final Object? extra;

  const ApprovalDetailView({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final reviewer = authState.currentUser;

    if (reviewer == null || extra is! DailyReportModel) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: const Center(
          child: Text('Rapor bilgisi bulunamadı veya oturum kapalı.'),
        ),
      );
    }

    final report = extra as DailyReportModel;

    return BlocProvider<ApprovalDetailCubit>(
      create: (context) => ApprovalDetailCubit(
        initialReport: report,
        reviewer: reviewer,
        reviewRepository: context.read<ReviewRepository>(),
        internshipRepository: context.read<InternshipRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: const _ApprovalDetailScaffold(),
    );
  }
}

class _ApprovalDetailScaffold extends StatefulWidget {
  const _ApprovalDetailScaffold();

  @override
  State<_ApprovalDetailScaffold> createState() =>
      _ApprovalDetailScaffoldState();
}

class _ApprovalDetailScaffoldState extends State<_ApprovalDetailScaffold> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _scoreController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final reviewer = authState.currentUser;
    final isAdvisor = reviewer?.role.isAdvisor ?? false;

    return BlocConsumer<ApprovalDetailCubit, ApprovalDetailState>(
      listener: (context, state) {
        if (state is ApprovalDetailSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor:
                  state.isApproved ? AppColors.success : AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        } else if (state is ApprovalDetailFailure) {
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: Text(
              'Rapor İnceleme & Onay',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: _buildBody(context, state, isAdvisor),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ApprovalDetailState state,
    bool isAdvisor,
  ) {
    if (state is ApprovalDetailLoading) {
      return LoadingView(message: state.message);
    }

    if (state is! ApprovalDetailLoaded) {
      return const SizedBox.shrink();
    }

    final report = state.report;
    final student = state.student;
    final internship = state.internship;
    final cubit = context.read<ApprovalDetailCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Öğrenci ve Staj Bilgi Kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppColors.primaryBlue.withValues(alpha: 0.12),
                  child: Text(
                    student?.fullName.isNotEmpty == true
                        ? student!.fullName[0].toUpperCase()
                        : 'Ö',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student?.fullName ?? 'Öğrenci',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Öğrenci No: ${student?.institutionId ?? '-'}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        internship?.companyName ?? 'Staj Kurumu',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Rapor Tarihi ve Durumu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatDateTurkish(report.workDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${report.hoursWorked} Çalışma Saati',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge(status: report.status),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Yapılan İşler Kartı
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
                  'Yapılan İşler ve Görevler',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.tasks,
                  style: AppTextStyles.body.copyWith(height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Öğrenilenler ve Kazanımlar Kartı
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
                  'Öğrenilenler ve Kazanımlar',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.learnings,
                  style: AppTextStyles.body.copyWith(height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Ekli Belgeler
          if (report.hasAttachments) ...[
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
                    'Ekli Belgeler (${report.attachmentPaths.length})',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...report.attachmentPaths.map((path) {
                    final fileName = path.split('/').last.split('?').first;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: AttachmentTile(fileName: fileName),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 6. Önceki İnceleme Geçmişi
          if (state.reviews.isNotEmpty) ...[
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
                    'İnceleme Geçmişi',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...state.reviews.map((rev) => _ReviewHistoryTile(review: rev)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 7. Danışman Puanlama ve Not Alanı (Yalnızca Danışmana Özel)
          if (isAdvisor) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.grade_rounded,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Akademik Değerlendirme & Puanlama',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Puan / Not (0 - 100 Arası, İsteğe Bağlı)',
                    hint: 'Örn: 90',
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Değerlendirme Açıklaması',
                    hint: 'Öğrencinin performansına ilişkin notunuz...',
                    controller: _commentController,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 8. Onay & Düzeltme Butonları
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'Düzeltme İste',
                  icon: Icons.edit_note_rounded,
                  onPressed: () => _showRevisionDialog(context, cubit),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  text: isAdvisor ? 'Nihai Onay Ver' : 'Raporu Onayla',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () {
                    final score = int.tryParse(_scoreController.text.trim());
                    final comment = _commentController.text.trim().isNotEmpty
                        ? _commentController.text.trim()
                        : null;
                    cubit.approve(score: score, comment: comment);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showRevisionDialog(BuildContext context, ApprovalDetailCubit cubit) {
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Düzeltme Talebi Açıklaması',
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(bottomSheetContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Lütfen öğrencinin raporunda düzeltmesini istediğiniz kısımları açıklayınız. Bu açıklama öğrenciye iletilecektir.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: commentCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Düzeltme gerekçesini detaylıca yazınız...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AppButton.danger(
                text: 'Düzeltme Talebini Gönder',
                icon: Icons.send_rounded,
                onPressed: () {
                  final text = commentCtrl.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen düzeltme açıklaması giriniz.'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  Navigator.of(bottomSheetContext).pop();
                  cubit.requestRevision(comment: text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewHistoryTile extends StatelessWidget {
  final ReviewModel review;

  const _ReviewHistoryTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final isApproved = review.decision == ReviewDecision.approved;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.reviewerRole.isCompany
                    ? 'Kurum Sorumlusu İncelemesi'
                    : 'Akademik Danışman İncelemesi',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (isApproved ? AppColors.success : AppColors.warning)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isApproved ? 'Onaylandı' : 'Düzeltme İstendi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isApproved ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
          if (review.score != null) ...[
            const SizedBox(height: 4),
            Text(
              'Verilen Not: ${review.score} / 100',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            DateFormatter.formatDateTime(review.createdAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
