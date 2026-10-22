import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/password_validation_indicator.dart';

/// Tüm ekranlardan açılabilen profil kartı / modal penceresi.
void showProfileModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const ProfileModalSheet(),
  );
}

class ProfileModalSheet extends StatefulWidget {
  const ProfileModalSheet({super.key});

  @override
  State<ProfileModalSheet> createState() => _ProfileModalSheetState();
}

class _ProfileModalSheetState extends State<ProfileModalSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  // Göz ikonları başlangıçta kapalı (şifre gizli) olarak başlar.
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Aygen Yıldırım');
    _emailController = TextEditingController(text: 'aygen@yildirim.dev');
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen isim ve e-posta alanlarını doldurun.'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    final newPass = _newPasswordController.text;
    if (newPass.isNotEmpty) {
      if (!PasswordValidationIndicator.isAllValid(newPass)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Yeni şifre en az bir büyük harf, bir rakam ve en az 8 karakter içermelidir!',
            ),
            backgroundColor: AppColors.errorContainer,
          ),
        );
        return;
      }

      if (newPass != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yeni şifreler birbiriyle eşleşmiyor!'),
            backgroundColor: AppColors.errorContainer,
          ),
        );
        return;
      }
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.tertiary, size: 20),
            SizedBox(width: 8),
            Text('Profil bilgileriniz ve şifreniz başarıyla güncellendi! 🌿'),
          ],
        ),
        backgroundColor: AppColors.surfaceContainerHigh,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
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
            // Sürükleme Çizgisi
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: AppRadius.fullRadius,
                ),
              ),
            ),

            // Üst Başlık
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil ve Hesap Ayarları',
                          style: AppTypography.headlineSmall.copyWith(
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'Kişisel bilgilerini ve şifreni yönet',
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
            ),

            const Divider(color: AppColors.outlineVariant, height: 1),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil Kartı Özeti
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: AppRadius.lgRadius,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text.isEmpty
                                    ? 'Aygen Yıldırım'
                                    : _nameController.text,
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '🌿 Doğa Dostu Kaşif • Seviye 4',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '30 Gün Seri • %84 İstikrar',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 11,
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

                  const SizedBox(height: 20),

                  // İsim Soyisim Alanı
                  Text(
                    'İsim ve Soyisim',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.badge, size: 20),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.mdRadius,
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // E-posta Alanı
                  Text(
                    'E-Posta Adresi',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, size: 20),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.mdRadius,
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Şifre Değiştir Bölümü
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_reset,
                        size: 18,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Şifre Değiştir',
                        style: AppTypography.headlineSmall.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 1. Mevcut Şifre
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    decoration: InputDecoration(
                      hintText: 'Mevcut Şifre',
                      prefixIcon: const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureOldPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.outline,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
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
                  const SizedBox(height: 10),

                  // 2. Yeni Şifre
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      hintText: 'Yeni Şifre',
                      prefixIcon: const Icon(Icons.vpn_key, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.outline,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
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

                  // Anlık Şifre Validasyon Göstergesi (Yeni Şifre için)
                  PasswordValidationIndicator(
                    controller: _newPasswordController,
                  ),

                  const SizedBox(height: 10),

                  // 3. Yeni Şifre (Tekrar)
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Yeni Şifre (Tekrar)',
                      prefixIcon: const Icon(Icons.check, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.outline,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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

                  const SizedBox(height: 24),

                  // Kaydet Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgRadius,
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Değişiklikleri Kaydet',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
