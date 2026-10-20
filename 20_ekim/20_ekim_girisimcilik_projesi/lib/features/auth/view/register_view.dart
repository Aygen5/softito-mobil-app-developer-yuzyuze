import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../../core/widgets/yorunge_logo.dart';
import '../../shell/view/shell_view.dart';
import '../controller/auth_controller.dart';
import '../widget/auth_banner.dart';
import '../widget/auth_text_field.dart';

/// Yörünge Kayıt Ekranı (RegisterView).
/// Form doğrulaması sonrası yerel demo oturumu başlatır veya tek tıkla hızlı demo sağlar.
class RegisterView extends StatefulWidget {
  final ThemeController themeController;
  final AuthController authController;

  const RegisterView({
    super.key,
    required this.themeController,
    required this.authController,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final success = await widget.authController.register(
      adSoyad: _nameController.text,
      email: _emailController.text,
      sifre: _passwordController.text,
      sifreTekrari: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tebrikler ${_nameController.text.trim()}! Yerel demo hesabınız oluşturuldu.',
          ),
          backgroundColor: context.spaceColors.ascensionLime,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _navigateToShell();
    }
  }

  Future<void> _handleQuickDemo() async {
    final success = await widget.authController.loginAsQuickDemo();
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Hızlı demo oturumu başlatıldı. Yörünge ekosistemine hoş geldiniz!',
          ),
          backgroundColor: context.spaceColors.nebulaCyan,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _navigateToShell();
    }
  }

  void _navigateToShell() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => ShellView(
          themeController: widget.themeController,
          authController: widget.authController,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StarfieldBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(colors),
                  const SizedBox(height: 16),
                  const AuthBanner(),
                  const SizedBox(height: 16),
                  _buildForm(colors),
                  const SizedBox(height: 20),
                  _buildActions(colors),
                  const SizedBox(height: 20),
                  _buildFooter(colors),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic colors) {
    return Column(
      children: [
        const YorungeLogo(size: 64),
        const SizedBox(height: 14),
        Text(
          'Yeni Girişimci Kaydı',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Yörünge ekosistemine yerel demo hesabınızla katılın',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(dynamic colors) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.authController.errorMessage,
      builder: (context, error, _) {
        return Column(
          children: [
            AuthTextField(
              controller: _nameController,
              label: AppStrings.adSoyad,
              hintText: 'Adınız ve Soyadınız',
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => widget.authController.clearError(),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _emailController,
              label: AppStrings.eposta,
              hintText: 'kurucu@girisim.io',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => widget.authController.clearError(),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _passwordController,
              label: AppStrings.sifre,
              hintText: 'En az 6 karakter',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              onChanged: (_) => widget.authController.clearError(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _confirmPasswordController,
              label: AppStrings.sifreTekrari,
              hintText: 'Şifrenizi tekrar girin',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onSubmitted: _handleRegister,
              onChanged: (_) => widget.authController.clearError(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.errorRed.withValues(alpha: 0.12),
                  borderRadius: AppSpacing.roundedSm,
                  border: Border.all(
                    color: colors.errorRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: colors.errorRed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.errorRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildActions(dynamic colors) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.authController.isLoading,
      builder: (context, loading, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: loading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.rocketFlame,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.roundedMd,
                ),
                elevation: 4,
                shadowColor: colors.rocketFlame.withValues(alpha: 0.4),
              ),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Kayıt Ol ve Başla',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: loading ? null : _handleQuickDemo,
              icon: Icon(Icons.bolt_rounded,
                  size: 18, color: colors.ascensionLime),
              label: Text(
                AppStrings.hizliDemoOlustur,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: BorderSide(
                  color: colors.border.withValues(alpha: 0.9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.roundedMd,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(dynamic colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Zaten bir hesabınız var mı?',
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () {
            widget.authController.clearError();
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              AppStrings.girisYap,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colors.nebulaCyan,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
