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

/// Öğrenci hesabı oluşturma ekranı.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yeni Hesap Oluştur'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
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

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Bilgilendirme Notu (Rol Güvenliği)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.infoLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBBDEFB),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 22,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Bu formdan açılan hesaplar Öğrenci rolündedir. Kurum ve danışman yetkileri kurum tarafından tanımlanır.',
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF0D47A1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Kayıt Kartı
                      AppCard(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Öğrenci Kaydı',
                              style: AppTextStyles.cardTitle,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Ad ve Soyad',
                              hint: 'Ahmet Yılmaz',
                              controller: _fullNameController,
                              prefixIcon: Icons.person_outline,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen adınızı ve soyadınızı giriniz.';
                                }
                                if (val.trim().length < 3) {
                                  return 'Ad ve soyad en az 3 karakter olmalıdır.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              label: 'E-posta Adresi',
                              hint: 'ogrenci@universite.edu.tr',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen e-posta adresinizi giriniz.';
                                }
                                if (!AppConstants.emailRegex.hasMatch(
                                  val.trim(),
                                )) {
                                  return 'Geçerli bir e-posta adresi yazınız.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              label: 'Şifre',
                              hint: '••••••••',
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Lütfen bir şifre belirleyiniz.';
                                }
                                if (val.trim().length <
                                    AppConstants.minPasswordLength) {
                                  return 'Şifre en az 6 karakter olmalıdır.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              label: 'Şifre Tekrarı',
                              hint: '••••••••',
                              controller: _confirmPasswordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              enabled: !isLoading,
                              validator: (val) {
                                if (val != _passwordController.text) {
                                  return 'Girdiğiniz şifreler eşleşmiyor.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                            AppButton(
                              text: 'Hesabımı Oluştur',
                              isLoading: isLoading,
                              onPressed: _onRegister,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Zaten hesabın var mı?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Zaten hesabınız var mı?',
                            style: AppTextStyles.subtitle,
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.pop();
                                  },
                            child: const Text('Giriş Yap'),
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
