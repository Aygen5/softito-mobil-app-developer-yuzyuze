import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../analiz/view/analiz.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/data/auth_mock_data.dart';
import '../../auth/view/login_view.dart';
import '../../fikir_durumu/view/fikir_durumu.dart';
import '../../mentor/view/mentor.dart';
import '../../programlar/view/programlar.dart';
import '../../topluluk/view/topluluk.dart';
import '../../yatirimci/view/yatirimci.dart';
import '../controller/shell_controller.dart';
import '../widget/shell_bottom_bar.dart';

class ShellView extends StatefulWidget {
  final ThemeController themeController;
  final AuthController? authController;

  const ShellView({
    super.key,
    required this.themeController,
    this.authController,
  });

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final ShellController _shellController;

  @override
  void initState() {
    super.initState();
    _shellController = ShellController();
  }

  @override
  void dispose() {
    _shellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StarfieldBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildTopBar(context),
        body: ValueListenableBuilder<int>(
          valueListenable: _shellController.seciliSekmeIndex,
          builder: (context, index, _) {
            return IndexedStack(
              index: index,
              children: [
                MentorView(authController: widget.authController),
                YatirimciView(authController: widget.authController),
                ProgramlarView(authController: widget.authController),
                ToplulukView(authController: widget.authController),
              ],
            );
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _shellController.seciliSekmeIndex,
          builder: (context, index, _) {
            return ShellBottomBar(
              seciliIndex: index,
              onTabSelected: _shellController.sekmeDegistir,
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context) {
    final colors = context.spaceColors;
    final isDark = context.isDark;

    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.nightBlue,
              border: Border.all(color: colors.border),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.rocket_launch_rounded,
                  size: 18,
                  color: colors.rocketFlame,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'İş Planı Analiz Testi',
          icon: Icon(Icons.assignment_outlined, color: colors.nebulaCyan),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => AnalizView(authController: widget.authController),
            ));
          },
        ),
        IconButton(
          tooltip: AppStrings.fikirDurumum,
          icon: Icon(Icons.rocket_rounded, color: colors.rocketFlame),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) =>
                  FikirDurumuView(authController: widget.authController),
            ));
          },
        ),
        IconButton(
          tooltip: isDark
              ? 'Şafak Moduna Geç (Aydınlık)'
              : 'Derin Uzaya Geç (Karanlık)',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? colors.ascensionLime : colors.starPurple,
          ),
          onPressed: widget.themeController.toggleTheme,
        ),
        if (widget.authController != null)
          IconButton(
            tooltip: 'Demo Profil / Rol Değiştir',
            icon: Icon(Icons.account_circle_outlined, color: colors.nebulaCyan),
            onPressed: () => _showProfileDialog(context),
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Future<void> _showProfileDialog(BuildContext context) async {
    final colors = context.spaceColors;
    final auth = widget.authController;
    final user = auth?.currentUser.value;

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
        title: Row(
          children: [
            Icon(Icons.badge_outlined, color: colors.nebulaCyan),
            const SizedBox(width: 8),
            const Text(
              'Aktif Demo Profili',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user.adSoyad,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    colors.rocketFlame.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.rol.displayName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colors.rocketFlame,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                        if (user.rol.name == 'entrepreneur') ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                user.isApproved
                                    ? Icons.verified_user_rounded
                                    : Icons.lock_clock_rounded,
                                size: 14,
                                color: user.isApproved
                                    ? colors.ascensionLime
                                    : colors.warningAmber,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user.isApproved
                                    ? 'Onaylı Girişimci (Tam Topluluk İzni)'
                                    : 'Aday Girişimci (Topluluk Onayı Bekliyor)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: user.isApproved
                                      ? colors.ascensionLime
                                      : colors.warningAmber,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Demo Rolünü Değiştir (Test):',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.nebulaCyan,
                  ),
                ),
                const SizedBox(height: 8),
                ...AuthMockData.tumDemoHesaplar.map((acc) {
                  final isCurrent = user?.email == acc.email;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(dialogCtx).pop();
                        await auth?.switchDemoAccount(acc);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${acc.rol.displayName} (${acc.adSoyad}) hesabına geçildi.'),
                            backgroundColor: colors.ascensionLime,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? colors.rocketFlame.withValues(alpha: 0.12)
                              : colors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrent
                                ? colors.rocketFlame
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(acc.rol.icon,
                                size: 18,
                                color: isCurrent
                                    ? colors.rocketFlame
                                    : colors.nebulaCyan),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${acc.rol.displayName} — ${acc.adSoyad}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    acc.email,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCurrent)
                              Icon(Icons.check_circle_rounded,
                                  size: 16, color: colors.rocketFlame),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('Kapat', style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await auth?.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => LoginView(
                    themeController: widget.themeController,
                    authController: auth ?? AuthController(),
                  ),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}
