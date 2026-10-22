import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/demo_action_tile.dart';
import '../cubit/onboarding_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.isDemoActive) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Stack(
            children: [
              // Arka plan ambiyans parıltıları
              Positioned(
                top: -40,
                left: MediaQuery.of(context).size.width / 2 - 120,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tertiaryContainer.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: -60,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Ana İçerik
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.margin,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // Logo ve Başlık
                    const BrandLogo(size: 72),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Verdant', style: AppTypography.displayLarge),
                        const SizedBox(width: 4),
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ZİHİNSEL DİNGİNLİK & ALIŞKANLIK',
                      style: AppTypography.labelCaps.copyWith(
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Editoryal Başlık
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 28,
                          height: 1.25,
                        ),
                        children: [
                          const TextSpan(text: 'Daha iyi bir sen,\n'),
                          TextSpan(
                            text: 'küçük adımlarla',
                            style: TextStyle(color: AppColors.primaryFixedDim),
                          ),
                          const TextSpan(text: ' başlar.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Alışkanlıklarını güçlendir, gelişimini keşfet ve her gün kendine biraz daha yaklaş.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Günün İlhamı Kartı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: AppRadius.xlRadius,
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: AppColors.primaryFixedDim,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '“Büyük değişimler, küçük adımların birikimidir.”',
                                  style: AppTypography.headlineSmall.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 2,
                                      color: AppColors.secondaryContainer,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'GÜNÜN İLHAMI',
                                      style: AppTypography.labelCaps.copyWith(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Butonlar
                    AppButton(
                      label: 'Giriş Yap',
                      icon: Icons.arrow_forward,
                      type: AppButtonType.primary,
                      onPressed: () {
                        context.read<OnboardingCubit>().continueAsDemo();
                      },
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Hesap Oluştur',
                      type: AppButtonType.secondary,
                      onPressed: () {
                        context.push('/register');
                      },
                    ),
                    const SizedBox(height: 12),
                    DemoActionTile(
                      onTap: () {
                        context.read<OnboardingCubit>().continueAsDemo();
                      },
                    ),

                    const SizedBox(height: 28),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.eco,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Bugün kendin için güzel bir adım at.',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
