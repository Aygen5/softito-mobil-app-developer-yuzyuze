import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';

/// Yetkisiz, pasif veya henüz Firestore profili tanımlanmamış kullanıcılar için bekleme ekranı.
class PendingApprovalView extends StatelessWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final message = state is AuthPendingApproval
                    ? state.message
                    : 'Hesabınız inceleniyor veya profil bilgileriniz henüz tanımlanmamıştır.';
                final email = state is AuthPendingApproval ? state.email : '';
                final uid = state is AuthPendingApproval ? state.uid : '';

                return AppCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warningLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.hourglass_empty_rounded,
                          size: 44,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hesap Onayı Bekleniyor',
                        style: AppTextStyles.cardTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'E-posta: $email',
                                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                              ),
                              if (uid.isNotEmpty)
                                Text(
                                  'UID: $uid',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Güvenli Çıkış Yap',
                        isOutlined: true,
                        onPressed: () {
                          context.read<AuthCubit>().signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
