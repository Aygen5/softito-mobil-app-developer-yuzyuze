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
import '../../../core/widgets/password_validation_indicator.dart';
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
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const _LoginModalSheet(),
                        );
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

class _LoginModalSheet extends StatefulWidget {
  const _LoginModalSheet();

  @override
  State<_LoginModalSheet> createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<_LoginModalSheet> {
  final _emailController = TextEditingController(text: 'aygen@yildirim.dev');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen e-posta ve şifrenizi girin.'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    if (!PasswordValidationIndicator.isAllValid(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Şifre en az bir büyük harf, bir rakam ve en az 8 karakter içermelidir!',
          ),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    context.read<OnboardingCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadius.fullRadius,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.mdRadius,
                  ),
                  child: const Icon(
                    Icons.login,
                    color: AppColors.onPrimaryContainer,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giriş Yap',
                        style: AppTypography.headlineSmall.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Alışkanlık ritüeline devam et',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.outlineVariant, height: 1),
            const SizedBox(height: 16),
            Text(
              'E-POSTA ADRESİ',
              style: AppTypography.labelCaps.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'aygen@yildirim.dev',
                prefixIcon: const Icon(Icons.mail_outline, size: 20),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PAROLA',
              style: AppTypography.labelCaps.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            // Canlı / Anlık Şifre Validasyon Göstergesi
            PasswordValidationIndicator(controller: _passwordController),
            const SizedBox(height: 20),
            AppButton(
              label: 'Giriş Yap',
              icon: Icons.arrow_forward,
              type: AppButtonType.primary,
              onPressed: _submitLogin,
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<OnboardingCubit>().continueAsDemo();
                },
                child: Text(
                  'Giriş yapmadan demo olarak devam et →',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
