import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/cubit/auth_cubit.dart';

/// Kurum Yetkilisi ve Akademik Danışman için Profil Görünümü.
class ReviewerProfileView extends StatelessWidget {
  final String title;

  const ReviewerProfileView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: LoadingView(message: 'Profil yükleniyor...')),
      );
    }

    final isCompany = user.role.isCompany;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          title,
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Profil Kartı
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
                    backgroundColor: AppColors.primaryNavy.withValues(
                      alpha: 0.12,
                    ),
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : 'Y',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primaryNavy,
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
                      isCompany
                          ? 'Rol: Kurum Yetkilisi / Şirket Sorumlusu'
                          : 'Rol: Akademik Danışman',
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

            // Hesap Detayları
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
                    'Yetkili Bilgileri',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.business_rounded,
                    label: isCompany ? 'Kurum / Şirket Kodu' : 'Akademik Kod',
                    value: user.institutionId ?? 'Belirtilmedi',
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Kayıt Tarihi',
                    value: DateFormatter.formatDateTurkish(user.createdAt),
                  ),
                  const Divider(height: 20),
                  _InfoRow(
                    icon: Icons.verified_user_outlined,
                    label: 'Yetki Durumu',
                    value: user.isActive ? 'Aktif Yetkili' : 'Pasif',
                  ),
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

            // Çıkış Yap Butonu
            AppButton.danger(
              text: 'Güvenli Çıkış Yap',
              icon: Icons.logout_rounded,
              onPressed: () => _confirmSignOut(context),
            ),

            const SizedBox(height: 32),
          ],
        ),
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
            'Yetkili oturumunu sonlandırmak istediğinize emin misiniz?',
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
                context.read<AuthRepository>().signOut();
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
