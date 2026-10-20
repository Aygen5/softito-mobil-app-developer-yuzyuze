import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../controller/yatirimci_controller.dart';
import '../models/yatirimci_model.dart';
import '../widget/yatirimci_card.dart';

class YatirimciView extends StatefulWidget {
  final YatirimciController? controller;
  final AuthController? authController;

  const YatirimciView({super.key, this.controller, this.authController});

  @override
  State<YatirimciView> createState() => _YatirimciViewState();
}

class _YatirimciViewState extends State<YatirimciView> {
  late final YatirimciController _controller;
  late final bool _internalController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = YatirimciController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleIletisim(YatirimciModel yatirimci) {
    if (yatirimci.iletisimTalebiGonderildi) return;

    final role = widget.authController?.currentRole;
    if (role != null && !PermissionService.canSendInvestmentRequest(role)) {
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
                  PermissionService.getDenialReason('investment_request'),
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

    final success =
        _controller.iletisimTalebiGonder(yatirimci.id, currentRole: role);
    if (!success) return;

    final colors = context.spaceColors;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${yatirimci.ad} kurumuna ön tanışma ve yatırım talebiniz iletildi!',
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SectionHeader(
                title: 'Yatırımcı Ağı',
                subtitle:
                    'Girişiminizi büyütecek sermaye ve stratejik ortaklar',
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          SliverToBoxAdapter(child: _buildSearchAndStageFilter()),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<YatirimciKategori>(
              valueListenable: _controller.seciliKategori,
              builder: (context, kat, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: SectionHeader(
                    title: kat.baslik,
                    subtitle: 'Bu kategoride listelenen yatırım kuruluşları',
                  ),
                );
              },
            ),
          ),
          _buildYatirimciList(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ValueListenableBuilder<YatirimciKategori>(
      valueListenable: _controller.seciliKategori,
      builder: (context, secili, _) {
        final colors = context.spaceColors;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: YatirimciKategori.values.map((kat) {
              final isSelected = kat == secili;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(kat.baslik),
                  selected: isSelected,
                  selectedColor: colors.rocketFlame,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : colors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (_) => _controller.kategoriSec(kat),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndStageFilter() {
    final colors = context.spaceColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _controller.aramaYap,
            style: TextStyle(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Yatırımcı, sektör veya portföy ara...',
              hintStyle: TextStyle(color: colors.textMuted),
              prefixIcon: Icon(Icons.search_rounded,
                  size: 20, color: colors.nebulaCyan),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.cancel_rounded,
                          size: 18, color: colors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        _controller.aramaYap('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: colors.surfaceSubtle,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colors.rocketFlame, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildStageFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStageFilterChips() {
    final colors = context.spaceColors;
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.seciliAsama,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text(AppStrings.tumu),
                selected: secili == null,
                selectedColor: colors.rocketFlame,
                labelStyle: TextStyle(
                  color: secili == null ? Colors.white : colors.textPrimary,
                  fontWeight:
                      secili == null ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                onSelected: (_) => _controller.asamaSec(null),
              ),
              const SizedBox(width: 6),
              ..._controller.asamalar.map(
                (asama) {
                  final isSelected = secili == asama;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(asama),
                      selected: isSelected,
                      selectedColor: colors.rocketFlame.withValues(alpha: 0.25),
                      checkmarkColor: colors.rocketFlame,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colors.rocketFlame
                            : colors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? colors.rocketFlame : colors.border,
                      ),
                      onSelected: (selected) {
                        _controller.asamaSec(selected ? asama : null);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildYatirimciList() {
    return ValueListenableBuilder<List<YatirimciModel>>(
      valueListenable: _controller.gorunenYatirimcilar,
      builder: (context, yatirimcilar, _) {
        final colors = context.spaceColors;

        if (yatirimcilar.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: colors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kriterlere Uygun Yatırımcı Bulunamadı',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        _controller.filtreleriTemizle();
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Filtreleri Sıfırla'),
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
              final yatirimci = yatirimcilar[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: YatirimciCard(
                  yatirimci: yatirimci,
                  onIletisim: () => _handleIletisim(yatirimci),
                ),
              );
            }, childCount: yatirimcilar.length),
          ),
        );
      },
    );
  }
}
