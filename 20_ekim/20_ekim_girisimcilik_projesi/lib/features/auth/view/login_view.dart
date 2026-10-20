import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../../core/widgets/yorunge_logo.dart';
import '../../shell/view/shell_view.dart';
import '../controller/auth_controller.dart';
import '../data/auth_mock_data.dart';
import '../models/user_model.dart';
import '../widget/auth_banner.dart';
import '../widget/auth_text_field.dart';
import 'register_view.dart';

/// Yörünge Giriş Ekranı (LoginView).
/// Kullanıcı e-posta/şifre ile demo girişi yapabilir veya doğrudan demo oturumu açabilir.
class LoginView extends StatefulWidget {
  final ThemeController themeController;
  final AuthController authController;

  const LoginView({
    super.key,
    required this.themeController,
    required this.authController,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  UserModel? _selectedDemoUser;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _selectedDemoUser = AuthMockData.girisimciOnayli;
    _emailController =
        TextEditingController(text: AuthMockData.demoEmailGirisimci);
    _passwordController = TextEditingController(text: AuthMockData.demoSifre);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSelectDemoUser(UserModel user) {
    setState(() {
      _selectedDemoUser = user;
      _emailController.text = user.email;
      _passwordController.text = AuthMockData.demoSifre;
    });
    widget.authController.clearError();
  }

  Future<void> _handleLogin() async {
    final success = await widget.authController.login(
      email: _emailController.text,
      sifre: _passwordController.text,
    );
    if (!mounted) return;

    if (success) {
      _navigateToShell();
    }
  }

  Future<void> _handleQuickDemo() async {
    final success = await widget.authController.loginAsQuickDemo();
    if (!mounted) return;

    if (success) {
      _navigateToShell();
    }
  }

  void _navigateToShell() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ShellView(
          themeController: widget.themeController,
          authController: widget.authController,
        ),
      ),
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
                  const SizedBox(height: 18),
                  AuthBanner(
                    showCredentials: true,
                    selectedDemoUser: _selectedDemoUser,
                    onSelectDemoUser: _onSelectDemoUser,
                  ),
                  const SizedBox(height: 18),
                  _buildForm(colors),
                  const SizedBox(height: 18),
                  _buildActions(colors),
                  const SizedBox(height: 22),
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
        const YorungeLogo(size: 72),
        const SizedBox(height: 16),
        Text(
          'Yörünge\'ye Hoş Geldiniz',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Fikrinizi yörüngeye fırlatmak için oturum açın',
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
              controller: _emailController,
              label: AppStrings.eposta,
              hintText: 'ornek@alanadi.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => widget.authController.clearError(),
            ),
            const SizedBox(height: 14),
            AuthTextField(
              controller: _passwordController,
              label: AppStrings.sifre,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: _handleLogin,
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
              onPressed: loading ? null : _handleLogin,
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
                      AppStrings.girisYap,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: loading ? null : _handleQuickDemo,
              icon: Icon(Icons.flash_on_rounded,
                  size: 18, color: colors.ascensionLime),
              label: Text(
                AppStrings.demoOlarakDevamEt,
                style: TextStyle(
                  fontSize: 14,
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
          'Henüz hesabınız yok mu?',
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () {
            widget.authController.clearError();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => RegisterView(
                  themeController: widget.themeController,
                  authController: widget.authController,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              AppStrings.kayitOl,
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
