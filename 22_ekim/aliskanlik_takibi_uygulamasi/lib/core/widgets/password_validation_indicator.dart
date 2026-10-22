import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Canlı (anlık) şifre güvenlik kuralları kontrol bileşeni.
///
/// Kriterler:
/// 1. En az bir büyük harf (Türkçe karakterler dahil: A-Z, Ç, Ğ, İ, Ö, Ş, Ü)
/// 2. En az bir rakam (0-9)
/// 3. En az 8 karakter (uzunluk >= 8)
class PasswordValidationIndicator extends StatelessWidget {
  final TextEditingController? controller;
  final String? password;

  const PasswordValidationIndicator({
    super.key,
    this.controller,
    this.password,
  }) : assert(
         controller != null || password != null,
         'Controller veya password parametrelerinden biri zorunludur.',
       );

  /// Şifrenin tüm kuralları sağlayıp sağlamadığını kontrol eden statik metot.
  static bool isAllValid(String password) {
    return hasUpperCase(password) &&
        hasDigit(password) &&
        hasMinLength(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r'[A-ZÇĞİÖŞÜ]').hasMatch(password);
  }

  static bool hasDigit(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  static bool hasMinLength(String password) {
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ListenableBuilder(
        listenable: controller!,
        builder: (context, _) {
          return _buildRules(controller!.text);
        },
      );
    }
    return _buildRules(password ?? '');
  }

  Widget _buildRules(String pwd) {
    final upperValid = hasUpperCase(pwd);
    final digitValid = hasDigit(pwd);
    final lengthValid = hasMinLength(pwd);

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security_outlined,
                size: 15,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 6),
              Text(
                'Şifre Güvenlik Kriterleri',
                style: AppTypography.labelCaps.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRuleRow(
            isValid: upperValid,
            label: 'En az bir büyük harf (A-Z)',
          ),
          const SizedBox(height: 6),
          _buildRuleRow(
            isValid: digitValid,
            label: 'En az bir rakam (0-9)',
          ),
          const SizedBox(height: 6),
          _buildRuleRow(
            isValid: lengthValid,
            label: 'En az 8 karakter',
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow({required bool isValid, required String label}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isValid
            ? AppColors.tertiary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: AppRadius.smRadius,
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Icon(
              isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              key: ValueKey<bool>(isValid),
              size: 16,
              color: isValid ? AppColors.tertiary : AppColors.outline,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: isValid ? AppColors.onSurface : AppColors.outline,
                fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
