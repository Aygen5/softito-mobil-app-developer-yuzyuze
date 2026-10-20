import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../../fikir_durumu/view/fikir_durumu.dart';
import '../controller/mentor_controller.dart';
import '../models/mentor_model.dart';
import '../widget/mentor_card.dart';
import '../widget/mentor_filter_bar.dart';

class MentorView extends StatefulWidget {
  final MentorController? controller;
  final AuthController? authController;

  const MentorView({super.key, this.controller, this.authController});

  @override
  State<MentorView> createState() => _MentorViewState();
}

class _MentorViewState extends State<MentorView> {
  late final MentorController _controller;
  late final bool _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = MentorController();
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

  void _handleEslesmeIste(MentorModel mentor) {
    if (mentor.durum != EslesmeDurumu.yok) return;

    final role = widget.authController?.currentRole;
    if (role != null && !PermissionService.canSendMentorshipRequest(role)) {
      final colors = context.spaceColors;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  PermissionService.getDenialReason('mentorship_request'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: colors.errorRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final success = _controller.eslesmeIste(mentor.id, currentRole: role);
    if (!success) return;

    final colors = context.spaceColors;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.rocket_launch_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${mentor.ad} ile eşleşme isteğiniz iletildi!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: colors.rocketFlame,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildIntroHeader()),
          SliverToBoxAdapter(child: _buildFilterSection()),
          SliverToBoxAdapter(child: _buildRecommendedSection()),
          SliverToBoxAdapter(child: _buildSectionDivider()),
          _buildMentorList(),
        ],
      ),
    );
  }

  Widget _buildIntroHeader() {
    final colors = context.spaceColors;
    return SectionHeader(
      title: 'Mentor & Danışman',
      subtitle: 'Girişiminize rehberlik edecek uzman havuzu',
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      trailing: IconButton(
        tooltip: AppStrings.fikirDurumum,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.rocketFlame.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(Icons.rocket_rounded, color: colors.rocketFlame, size: 20),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const FikirDurumuView()),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _controller.seciliSektor,
        _controller.aramaMetni,
      ]),
      builder: (context, _) {
        return MentorFilterBar(
          sektorler: _controller.sektorler,
          seciliSektor: _controller.seciliSektor.value,
          aramaMetni: _controller.aramaMetni.value,
          onSektorSelected: _controller.sektorSec,
          onSearchChanged: _controller.aramaYap,
          onClearAll: _controller.filtreleriTemizle,
        );
      },
    );
  }

  Widget _buildRecommendedSection() {
    return ValueListenableBuilder<List<MentorModel>>(
      valueListenable: _controller.tumMentorlar,
      builder: (context, tumList, _) {
        // Arama veya sektör filtresi aktifse, sonuçları öne çıkarmak için yatay carousel'i gizle
        if (_controller.isFilterActive) {
          return const SizedBox.shrink();
        }

        final onerilenler = _controller.onerilenMentorlar;
        if (onerilenler.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SectionHeader(
                title: 'Öne Çıkan Mentorlar',
                subtitle: 'En yüksek değerlendirmeye sahip uzmanlar',
              ),
            ),
            SizedBox(
              height: 295,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: onerilenler.length,
                itemBuilder: (context, index) {
                  final m = onerilenler[index];
                  return SizedBox(
                    width: 320,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: MentorCard(
                        mentor: m,
                        onEslesmeIste: () => _handleEslesmeIste(m),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionDivider() {
    return ListenableBuilder(
      listenable: Listenable.merge([
        _controller.seciliSektor,
        _controller.aramaMetni,
        _controller.gorunenMentorlar,
      ]),
      builder: (context, _) {
        final colors = context.spaceColors;
        final count = _controller.gorunenMentorlar.value.length;
        final isFilter = _controller.isFilterActive;

        return SectionHeader(
          title: isFilter ? 'Filtrelenen Mentorlar' : 'Tüm Mentor Havuzu',
          subtitle: isFilter
              ? '$count mentor listeleniyor'
              : 'Uzmanlık ve sektöre göre danışmanlar ($count)',
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          trailing: isFilter
              ? TextButton.icon(
                  onPressed: _controller.filtreleriTemizle,
                  icon: const Icon(Icons.clear_all_rounded, size: 16),
                  label: const Text('Filtreyi Temizle'),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.rocketFlame,
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildMentorList() {
    return ValueListenableBuilder<List<MentorModel>>(
      valueListenable: _controller.gorunenMentorlar,
      builder: (context, mentorlar, _) {
        final colors = context.spaceColors;

        if (mentorlar.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search_rounded,
                      size: 64,
                      color: colors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aramanıza Uygun Mentor Bulunamadı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lütfen farklı bir uzmanlık alanı veya sektör deneyin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: colors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _controller.filtreleriTemizle,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Tüm Mentorları Göster'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.rocketFlame,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final mentor = mentorlar[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MentorCard(
                  mentor: mentor,
                  onEslesmeIste: () => _handleEslesmeIste(mentor),
                ),
              );
            }, childCount: mentorlar.length),
          ),
        );
      },
    );
  }
}
