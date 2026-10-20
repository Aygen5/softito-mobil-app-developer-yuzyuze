import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../controller/topluluk_controller.dart';
import '../models/topluluk_model.dart';
import '../widget/topluluk_gonderi_card.dart';

class ToplulukView extends StatefulWidget {
  final ToplulukController? controller;
  final AuthController? authController;

  const ToplulukView({super.key, this.controller, this.authController});

  @override
  State<ToplulukView> createState() => _ToplulukViewState();
}

class _ToplulukViewState extends State<ToplulukView> {
  late final ToplulukController _controller;
  late final bool _internalController;
  final TextEditingController _metinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final role = widget.authController?.currentRole;
    final isApproved = widget.authController?.isApproved ?? true;
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = ToplulukController(
        baslangicDurumu: isApproved
            ? ToplulukKullaniciDurumu.onayli
            : ToplulukKullaniciDurumu.onaysiz,
        baslangicRol: role,
      );
      _internalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant ToplulukView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.authController != oldWidget.authController) {
      final role = widget.authController?.currentRole;
      final isApproved = widget.authController?.isApproved ?? true;
      _controller.rolAyarla(role);
      _controller.kullaniciDurumuAyarla(
        isApproved
            ? ToplulukKullaniciDurumu.onayli
            : ToplulukKullaniciDurumu.onaysiz,
      );
    }
  }

  @override
  void dispose() {
    _metinController.dispose();
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _showPermissionDialog() {
    final colors = context.spaceColors;
    final role =
        widget.authController?.currentRole ?? _controller.aktifRol.value;
    final isApproved =
        _controller.kullaniciDurumu.value == ToplulukKullaniciDurumu.onayli;

    String aciklama;
    bool canToggleApproval = false;

    if (role != null &&
        role != UserRole.entrepreneur &&
        role != UserRole.admin) {
      aciklama =
          'Toplulukta gönderi paylaşımı, beğeni ve yanıtlar yalnızca onaylanmış girişimcilere ve platform yöneticisine açıktır.\n\n'
          'Mevcut rolünüz (${role.displayName}) topluluk akışını yalnızca izleyebilir.';
    } else if (!isApproved) {
      aciklama =
          'Yörünge ekosisteminde gönderi paylaşımı, beğeni ve yanıtlar için girişimci hesabınızın onaylanmış olması gerekir.\n\n'
          'Demo sürecini test etmek için aşağıdaki butona dokunarak onaylı moda geçebilirsiniz.';
      canToggleApproval = true;
    } else {
      aciklama = PermissionService.getDenialReason('community_post');
    }

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor:
              context.isDark ? colors.nightBlue : colors.surfaceDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.lock_rounded, color: colors.warningAmber, size: 22),
              const SizedBox(width: 10),
              const Text('Etkileşim Yetkisi'),
            ],
          ),
          content: Text(
            aciklama,
            style: TextStyle(
                color: colors.textSecondary, fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Anladım'),
            ),
            if (canToggleApproval)
              ElevatedButton.icon(
                onPressed: () {
                  _controller
                      .kullaniciDurumuAyarla(ToplulukKullaniciDurumu.onayli);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Onaylı Girişimci modu aktif edildi!'),
                      backgroundColor: colors.ascensionLime,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.verified_rounded, size: 16),
                label: const Text('Onaylı Moda Geç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.rocketFlame,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        );
      },
    );
  }

  void _showNewPostDialog() {
    _metinController.clear();
    final colors = context.spaceColors;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toplulukta Paylaşım Yap',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _metinController,
                maxLength: 280,
                maxLines: 4,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText:
                      'Gelişmeleri, deneyimlerinizi veya sorularınızı paylaşın (en fazla 280 karakter)...',
                  hintStyle: TextStyle(color: colors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final basarili = _controller.gonderiEkle(
                      metin: _metinController.text,
                    );
                    if (basarili) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Gönderiniz başarıyla paylaşıldı!'),
                          backgroundColor: colors.ascensionLime,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      _showPermissionDialog();
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text(AppStrings.paylas),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.rocketFlame,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReplyDialog(String gonderiId) {
    _metinController.clear();
    final colors = context.spaceColors;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gönderiye Yanıt Yaz',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _metinController,
                maxLength: 280,
                maxLines: 3,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Yanıtınız (en fazla 280 karakter)...',
                  hintStyle: TextStyle(color: colors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final basarili = _controller.yanitEkle(
                      gonderiId: gonderiId,
                      metin: _metinController.text,
                    );
                    if (basarili) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Yanıtınız başarıyla eklendi!'),
                          backgroundColor: colors.ascensionLime,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      _showPermissionDialog();
                    }
                  },
                  icon: const Icon(Icons.reply_rounded, size: 16),
                  label: const Text('Yanıtla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.rocketFlame,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToplulukKullaniciDurumu>(
      valueListenable: _controller.kullaniciDurumu,
      builder: (context, durum, _) {
        return ValueListenableBuilder<UserRole?>(
          valueListenable: _controller.aktifRol,
          builder: (context, rol, _) {
            final paylasabilir = _controller.paylasabilir;

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  _buildTopHeader(durum),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        _buildGonderiList(paylasabilir),
                      ],
                    ),
                  ),
                  if (!paylasabilir) _buildPermissionWarningBanner(rol),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed:
                    paylasabilir ? _showNewPostDialog : _showPermissionDialog,
                icon: Icon(paylasabilir
                    ? Icons.edit_note_rounded
                    : Icons.lock_outline_rounded),
                label: Text(
                    paylasabilir ? AppStrings.paylas : 'Yetki / Onay Durumu'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopHeader(ToplulukKullaniciDurumu durum) {
    final colors = context.spaceColors;
    final isApproved = durum == ToplulukKullaniciDurumu.onayli;

    return SectionHeader(
      title: 'Girişimci Topluluğu',
      subtitle: 'Kabul edilmiş girişimcilerin mikro-paylaşım akışı',
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      trailing: InkWell(
        onTap: () {
          _controller.kullaniciDurumuAyarla(
            isApproved
                ? ToplulukKullaniciDurumu.onaysiz
                : ToplulukKullaniciDurumu.onayli,
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: (isApproved ? colors.ascensionLime : colors.warningAmber)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (isApproved ? colors.ascensionLime : colors.warningAmber)
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isApproved
                    ? Icons.verified_user_rounded
                    : Icons.lock_outline_rounded,
                size: 14,
                color: isApproved ? colors.ascensionLime : colors.warningAmber,
              ),
              const SizedBox(width: 6),
              Text(
                isApproved ? 'Onaylı' : 'Onaysız',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color:
                      isApproved ? colors.ascensionLime : colors.warningAmber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionWarningBanner(UserRole? rol) {
    final colors = context.spaceColors;
    final isNonEntrepreneur =
        rol != null && rol != UserRole.entrepreneur && rol != UserRole.admin;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colors.warningAmber.withValues(alpha: 0.15),
        border: Border(
          top: BorderSide(color: colors.warningAmber.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: colors.warningAmber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isNonEntrepreneur
                  ? 'Gözlemci modundasınız (${rol.displayName}). Gönderileri okuyabilirsiniz; paylaşım ve etkileşim yetkisi bulunmamaktadır.'
                  : 'Onaysız moddasınız. Gönderileri okuyabilirsiniz; paylaşım ve beğeni için onay gerekir.',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 11,
              ),
            ),
          ),
          if (!isNonEntrepreneur)
            TextButton(
              onPressed: () {
                _controller
                    .kullaniciDurumuAyarla(ToplulukKullaniciDurumu.onayli);
              },
              child: Text(
                'Onayla',
                style: TextStyle(
                  color: colors.ascensionLime,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGonderiList(bool paylasabilir) {
    return ValueListenableBuilder<List<ToplulukGonderiModel>>(
      valueListenable: _controller.gonderiler,
      builder: (context, gonderiler, _) {
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final gonderi = gonderiler[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ToplulukGonderiCard(
                  gonderi: gonderi,
                  paylasabilir: paylasabilir,
                  onBegeni: () {
                    final ok = _controller.begeniDegistir(gonderi.id);
                    if (!ok) _showPermissionDialog();
                  },
                  onYanitla: () {
                    if (paylasabilir) {
                      _showReplyDialog(gonderi.id);
                    } else {
                      _showPermissionDialog();
                    }
                  },
                ),
              );
            }, childCount: gonderiler.length),
          ),
        );
      },
    );
  }
}
