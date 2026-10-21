import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';

/// Şifre sıfırlama talebi ekranı.
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().sendPasswordReset(email: _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
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
                final isSent = state is PasswordResetSent;

                if (isSent) {
                  return AppCard(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            size: 40,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Sıfırlama Bağlantısı Gönderildi',
                          style: AppTextStyles.cardTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${state.email} adresine şifre yenileme bağlantısı gönderildi. Lütfen gelen kutunuzu kontrol ediniz.',
                          style: AppTextStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Giriş Ekranına Dön',
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  );
                }

                return Form(
                  key: _formKey,
                  child: AppCard(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Şifrenizi mi Unuttunuz?',
                          style: AppTextStyles.cardTitle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kayıtlı e-posta adresinizi giriniz. Size şifre sıfırlama bağlantısı göndereceğiz.',
                          style: AppTextStyles.subtitle,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Sıfırlama Bağlantısı Gönder',
                          isLoading: isLoading,
                          onPressed: _onReset,
                        ),
                      ],
                    ),
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
