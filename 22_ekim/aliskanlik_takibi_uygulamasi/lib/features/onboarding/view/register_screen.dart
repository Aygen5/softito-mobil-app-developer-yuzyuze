import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/brand_logo.dart';
import '../cubit/onboarding_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController(text: 'Aygen Kaya');
  final _emailController = TextEditingController(text: 'aygen@example.com');
  final _passwordController = TextEditingController(text: 'verdant123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.isDemoActive) {
          context.go('/home');
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.errorContainer,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Üst Bar: Geri Dön Butonu ve Ritüel Alanı Rozeti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mdRadius,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh.withValues(
                          alpha: 0.6,
                        ),
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Ritüel Alanı',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Logo ve Başlık
                const BrandLogo(size: 64),
                const SizedBox(height: 12),
                Text(
                  'VERDANT',
                  style: AppTypography.labelCaps.copyWith(
                    letterSpacing: 2.0,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yeni bir başlangıç yap.',
                  style: AppTypography.headlineLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Kendin için sürdürülebilir alışkanlıklar oluştur ve sakin bir ritim yakala.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 28),

                // Form Alanları
                // 1. Ad Soyad
                _buildInputField(
                  label: 'AD SOYAD',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hint: 'Örn. Aygen Kaya',
                ),

                const SizedBox(height: 16),

                // 2. E-Posta
                _buildInputField(
                  label: 'E-POSTA ADRESİ',
                  controller: _emailController,
                  icon: Icons.mail_outline,
                  hint: 'aygen@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // 3. Parola
                _buildInputField(
                  label: 'PAROLA',
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Gizlilik & Güvenlik Hapı
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        color: AppColors.tertiary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gizliliğinize önem veriyoruz • Tamamen cihazınızda güvenli',
                          style: AppTypography.caption,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Kayıt Ol Butonu
                AppButton(
                  label: 'Hesap Oluştur',
                  icon: Icons.eco,
                  type: AppButtonType.primary,
                  onPressed: () {
                    context.read<OnboardingCubit>().register(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Değer Kartları (Bento)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: AppRadius.lgRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: AppRadius.mdRadius,
                              ),
                              child: const Icon(
                                Icons.spa,
                                color: AppColors.tertiary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sakin Ritim',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '10-15 dk',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: AppRadius.lgRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer.withValues(
                                  alpha: 0.4,
                                ),
                                borderRadius: AppRadius.mdRadius,
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: AppColors.tertiary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Süreklilik',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '%100 Cihazda',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelCaps.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: AppRadius.lgRadius,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.outline, size: 20),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.outlineVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
