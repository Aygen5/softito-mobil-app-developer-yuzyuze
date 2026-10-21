import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_card.dart';
import '../../../features/auth/cubit/auth_cubit.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Faz 4, 5 ve 6 geliştirilmelerine kadar alt sekmeleri temsil eden yer tutucu kabuk görünümü.
class ShellPlaceholderView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ShellPlaceholderView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final user = state is Authenticated ? state.user : null;

                return AppCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 40, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(height: 16),
                      Text(title, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      if (user != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'Kullanıcı: ${user.fullName} (${user.role.label})',
                            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Oturumu Kapat',
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
