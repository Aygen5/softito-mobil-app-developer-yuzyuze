import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';

/// Stitch Screen 1 referansına tam uyumlu Giriş Ekranı.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Uygulama Marka Logosu & Başlık
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowMedium,
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 44,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'StajTakip',
                        style: AppTextStyles.screenTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dijital Staj Defteri ve Onay Sistemi',
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Giriş Kartı
                      AppCard(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Giriş Yap',
                              style: AppTextStyles.cardTitle,
                            ),
                            const SizedBox(height: 18),
                            AppTextField(
                              label: 'E-posta Adresi',
                              hint: 'ornek@universite.edu.tr',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen e-posta adresinizi giriniz.';
                                }
                                if (!AppConstants.emailRegex.hasMatch(val.trim())) {
                                  return 'Geçerli bir e-posta adresi yazınız.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Şifre',
                              hint: '••••••••',
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen şifrenizi giriniz.';
                                }
                                if (val.trim().length < AppConstants.minPasswordLength) {
                                  return 'Şifre en az 6 karakter olmalıdır.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.push(RouteNames.forgotPassword);
                                      },
                                child: const Text('Şifremi Unuttum'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              text: 'Giriş Yap',
                              isLoading: isLoading,
                              onPressed: _onLogin,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Kayıt Ol Yönlendirmesi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Henüz hesabınız yok mu?',
                            style: AppTextStyles.subtitle,
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.push(RouteNames.register);
                                  },
                            child: const Text('Öğrenci Kaydı Aç'),
                          ),
                        ],
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
