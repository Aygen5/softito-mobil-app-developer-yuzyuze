import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// Öğrenci Profil ve Hesap Ayarları Görünümü.
class StudentProfileView extends StatelessWidget {
  const StudentProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = (authState is AuthAuthenticated) ? authState.user : null;

    if (user == null) {
      return const Scaffold(
        body: Center(child: LoadingView(message: 'Profil yükleniyor...')),
      );
    }

    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        initialUser: user,
        userRepository: context.read<UserRepository>(),
        internshipRepository: context.read<InternshipRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _ProfileScaffold(),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Profilim',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const LoadingView(
              message: 'Kullanıcı bilgileri alınıyor...',
            );
          }

          if (state is ProfileError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.user;
            final internship = state.activeInternship;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Profil Başlık Kartı
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryBlue.withValues(
                            alpha: 0.12,
                          ),
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'Ö',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user.fullName,
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'Rol: Öğrenci',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hesap Detayları Kartı
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hesap Detayları',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Öğrenci / Kurum No',
                          value: user.institutionId ?? 'Belirtilmedi',
                        ),
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Kayıt Tarihi',
                          value: DateFormatter.formatDateTurkish(
                            user.createdAt,
                          ),
                        ),
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.check_circle_outline,
                          label: 'Hesap Durumu',
                          value: user.isActive ? 'Aktif' : 'Pasif',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Aktif Staj Bilgileri Kartı
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aktif Staj Bilgileri',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (internship != null) ...[
                          _InfoRow(
                            icon: Icons.business_outlined,
                            label: 'Kurum / Şirket',
                            value: internship.companyName,
                          ),
                          const Divider(height: 20),
                          _InfoRow(
                            icon: Icons.date_range_outlined,
                            label: 'Staj Tarihleri',
                            value:
                                '${DateFormatter.formatDateTurkish(internship.startDate)} — ${DateFormatter.formatDateTurkish(internship.endDate)}',
                          ),
                          const Divider(height: 20),
                          _InfoRow(
                            icon: Icons.timer_outlined,
                            label: 'Zorunlu İş Günü',
                            value: '${internship.requiredDays} Gün',
                          ),
                          const Divider(height: 20),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.pushNamed(
                                RouteNames.studentPdfPreviewName,
                                extra: internship.id,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf_outlined,
                                    size: 20,
                                    color: AppColors.primaryBlue,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Resmî Staj Defteri PDF Görüntüle',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Adınıza kayıtlı aktif staj bulunmamaktadır.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Uygulama Hakkında
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          icon: Icons.info_outline,
                          label: 'Uygulama Sürümü',
                          value: '${AppConstants.appName} v1.0.0',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Güvenli Çıkış Butonu
                  AppButton.danger(
                    text: 'Güvenli Çıkış Yap',
                    icon: Icons.logout_rounded,
                    onPressed: () => _confirmSignOut(context),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Oturumu Kapat'),
          content: const Text(
            'StajTakip uygulamasından çıkış yapmak istediğinize emin misiniz?',
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
                context.read<ProfileCubit>().signOut();
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
