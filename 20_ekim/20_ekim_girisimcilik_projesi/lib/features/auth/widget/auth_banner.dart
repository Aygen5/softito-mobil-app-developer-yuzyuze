import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../data/auth_mock_data.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

/// Kullanıcıya uygulamanın bir yerel demo ortamı olduğunu açıkça belirten ve
/// beş farklı rolün demo hesaplarını seçmesini sağlayan bilgilendirme kartı.
class AuthBanner extends StatelessWidget {
  final bool showCredentials;
  final ValueChanged<UserModel>? onSelectDemoUser;
  final UserModel? selectedDemoUser;

  const AuthBanner({
    super.key,
    this.showCredentials = false,
    this.onSelectDemoUser,
    this.selectedDemoUser,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.nebulaCyan.withValues(alpha: 0.08),
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(
          color: colors.nebulaCyan.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: colors.nebulaCyan,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bu uygulama portfolyo ve demo amaçlıdır. Beş farklı kullanıcı rolünü test etmek için aşağıdaki demo hesaplarından birini seçebilirsiniz.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (showCredentials) ...[
            const SizedBox(height: 10),
            Text(
              'Hızlı Rol Seçimi (Demo Hesapları):',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.ascensionLime,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AuthMockData.tumDemoHesaplar.map((user) {
                  final isSelected = selectedDemoUser?.email == user.email;
                  final label = user.rol == UserRole.entrepreneur
                      ? (user.isApproved
                          ? 'Girişimci (Onaylı)'
                          : 'Girişimci (Onaysız)')
                      : user.rol.displayName;

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => onSelectDemoUser?.call(user),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.rocketFlame.withValues(alpha: 0.25)
                              : colors.surfaceDark.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? colors.rocketFlame
                                : colors.border.withValues(alpha: 0.7),
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.rol.icon,
                              size: 13,
                              color: isSelected
                                  ? colors.rocketFlame
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? colors.textPrimary
                                    : colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seçilen E-posta: ${selectedDemoUser?.email ?? AuthMockData.demoEmail}  •  Şifre: ${AuthMockData.demoSifre}',
              style: TextStyle(
                fontSize: 10.5,
                fontFamily: 'monospace',
                color: colors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
