import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../../fikir_durumu/view/fikir_durumu.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';
import '../widget/analiz_adim_ekip.dart';
import '../widget/analiz_adim_fikir.dart';
import '../widget/analiz_adim_inovasyon.dart';
import '../widget/analiz_adim_marka.dart';
import '../widget/analiz_adim_ozet.dart';
import '../widget/analiz_adim_pazar.dart';
import '../widget/analiz_adim_plan.dart';
import '../widget/analiz_adim_traction.dart';

class AnalizView extends StatefulWidget {
  final AnalizController? controller;
  final AuthController? authController;

  const AnalizView({super.key, this.controller, this.authController});

  @override
  State<AnalizView> createState() => _AnalizViewState();
}

class _AnalizViewState extends State<AnalizView> {
  late final AnalizController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = AnalizController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSuccessSubmission() {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.basvuruGonderildi)));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const FikirDurumuView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.authController?.currentRole;
    final isObserver =
        role != null && !PermissionService.canCreateBusinessPlan(role);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.analizBaslik),
        actions: [_buildDraftNotification()],
      ),
      body: Column(
        children: [
          if (isObserver) _buildObserverBanner(role),
          _buildStepProgressIndicator(),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _controller.aktifAdim,
              builder: (context, adim, _) {
                return ValueListenableBuilder<AnalizFormModel>(
                  valueListenable: _controller.formState,
                  builder: (context, form, _) {
                    return _buildStepBody(adim, form);
                  },
                );
              },
            ),
          ),
          _buildNavigationFooter(),
        ],
      ),
    );
  }

  Widget _buildObserverBanner(UserRole role) {
    final colors = context.spaceColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.warningAmber.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(color: colors.warningAmber.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: colors.warningAmber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Gözlemci Modu (${role.displayName}): İş planı adımlarını inceleyebilirsiniz. Yeni iş planı oluşturma/gönderme yetkisi yalnızca Girişimci ve Platform Yöneticisine aittir.',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftNotification() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.taslakKaydedildiBildirimi,
      builder: (context, kaydedildi, _) {
        if (!kaydedildi) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Icon(
                Icons.cloud_done_rounded,
                size: 16,
                color: context.spaceColors.ascensionLime,
              ),
              const SizedBox(width: 4),
              Text(
                'Taslak Kaydedildi',
                style: TextStyle(
                  fontSize: 11,
                  color: context.spaceColors.ascensionLime,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepProgressIndicator() {
    final colors = context.spaceColors;
    return ValueListenableBuilder<int>(
      valueListenable: _controller.aktifAdim,
      builder: (context, adim, _) {
        final progress = (adim + 1) / _controller.adimBasliklari.length;
        return Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.rocketFlame),
              minHeight: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adım ${adim + 1} / ${_controller.adimBasliklari.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.rocketFlame,
                    ),
                  ),
                  Text(
                    _controller.adimBasliklari[adim],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepBody(int adim, AnalizFormModel form) {
    switch (adim) {
      case 0:
        return AnalizAdimFikir(controller: _controller, form: form);
      case 1:
        return AnalizAdimEkip(controller: _controller, form: form);
      case 2:
        return AnalizAdimTraction(controller: _controller, form: form);
      case 3:
        return AnalizAdimInovasyon(controller: _controller, form: form);
      case 4:
        return AnalizAdimPlan(controller: _controller, form: form);
      case 5:
        return AnalizAdimPazar(controller: _controller, form: form);
      case 6:
        return AnalizAdimMarka(controller: _controller, form: form);
      case 7:
        return AnalizAdimOzet(
          controller: _controller,
          form: form,
          onGonderildi: _onSuccessSubmission,
          userRole: widget.authController?.currentRole,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationFooter() {
    return ValueListenableBuilder<int>(
      valueListenable: _controller.aktifAdim,
      builder: (context, adim, _) {
        final sonAdim = adim == _controller.adimBasliklari.length - 1;
        if (sonAdim) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.isDark
                ? context.spaceColors.nightBlue
                : context.spaceColors.surfaceDark,
            border: Border(top: BorderSide(color: context.spaceColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (adim > 0)
                OutlinedButton.icon(
                  onPressed: _controller.oncekiAdim,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text(AppStrings.geri),
                )
              else
                const SizedBox(width: 80),
              ElevatedButton.icon(
                onPressed: _controller.sonrakiAdim,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text(AppStrings.ileri),
              ),
            ],
          ),
        );
      },
    );
  }
}
