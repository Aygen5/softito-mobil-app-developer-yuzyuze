import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../controller/fikir_durumu_controller.dart';
import '../models/fikir_durumu_model.dart';
import '../widget/avukat_karti.dart';
import '../widget/gelir_destek_karti.dart';
import '../widget/hukuki_surec_timeline.dart';

class FikirDurumuView extends StatefulWidget {
  final FikirDurumuController? controller;
  final AuthController? authController;

  const FikirDurumuView({super.key, this.controller, this.authController});

  @override
  State<FikirDurumuView> createState() => _FikirDurumuViewState();
}

class _FikirDurumuViewState extends State<FikirDurumuView> {
  late final FikirDurumuController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = FikirDurumuController();
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

  @override
  Widget build(BuildContext context) {
    final role = widget.authController?.currentRole;
    final isObserver =
        role != null && !PermissionService.canViewIdeaStatus(role);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.fikirDurumum)),
      body: ValueListenableBuilder<int>(
        valueListenable: _controller.seciliFikirIndex,
        builder: (context, seciliIndex, _) {
          return ValueListenableBuilder<List<FikirDurumuModel>>(
            valueListenable: _controller.fikirler,
            builder: (context, fikirler, _) {
              final fikir = fikirler[seciliIndex];

              return CustomScrollView(
                slivers: [
                  if (isObserver)
                    SliverToBoxAdapter(
                      child: _buildObserverBanner(role),
                    ),
                  SliverToBoxAdapter(
                    child: _buildIdeaSelector(fikirler, seciliIndex),
                  ),
                  SliverToBoxAdapter(child: _buildStatusBanner(fikir)),
                  const SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Hukuki Danışmanlık ve Şirketleşme',
                      subtitle:
                          'Yörünge tarafından atanan ücretsiz avukat ve T.C. mevzuat adımları',
                    ),
                  ),
                  SliverToBoxAdapter(child: AvukatKarti(avukat: fikir.avukat)),
                  SliverToBoxAdapter(
                    child: HukukiSurecTimeline(adimlar: fikir.hukukiAdimlar),
                  ),
                  const SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Gelir ve Ciro Destek Taahhüdü',
                      subtitle:
                          'Platformun büyüme aşamasındaki finansal güvencesi',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GelirDestekKarti(gelirDestegi: fikir.gelirDestegi),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIdeaSelector(List<FikirDurumuModel> fikirler, int seciliIndex) {
    final colors = context.spaceColors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: fikirler.asMap().entries.map((entry) {
          final idx = entry.key;
          final f = entry.value;
          final isSelected = idx == seciliIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f.fikirAdi),
              selected: isSelected,
              selectedColor: colors.rocketFlame,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : colors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) => _controller.fikirSec(idx),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusBanner(FikirDurumuModel fikir) {
    final colors = context.spaceColors;
    Color badgeColor;
    IconData badgeIcon;

    switch (fikir.basvuruAsamasi) {
      case BasvuruAsamasi.onaylandi:
        badgeColor = colors.ascensionLime;
        badgeIcon = Icons.verified_rounded;
        break;
      case BasvuruAsamasi.inceleniyor:
        badgeColor = colors.nebulaCyan;
        badgeIcon = Icons.hourglass_top_rounded;
        break;
      case BasvuruAsamasi.revizeIstendi:
        badgeColor = colors.warningAmber;
        badgeIcon = Icons.edit_note_rounded;
        break;
      case BasvuruAsamasi.gonderildi:
        badgeColor = colors.rocketFlame;
        badgeIcon = Icons.send_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(badgeIcon, color: badgeColor, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fikir.basvuruAsamasi.baslik,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                    Text(
                      fikir.sektor,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  fikir.aciklama,
                  style: TextStyle(fontSize: 12, color: colors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObserverBanner(UserRole role) {
    final colors = context.spaceColors;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.warningAmber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.warningAmber.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: colors.warningAmber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Gözlemci Modu (${role.displayName}): Kendi fikir durumunu ve şirketleşme sürecini takip etme yetkisi Girişimci ve Platform Yöneticisine aittir. Şu an örnek fikir verilerini inceliyorsunuz.',
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
}
