import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/permission_service.dart';
import '../controller/programlar_controller.dart';
import '../models/program_model.dart';
import '../widget/program_card.dart';

class ProgramlarView extends StatefulWidget {
  final ProgramlarController? controller;
  final AuthController? authController;

  const ProgramlarView({super.key, this.controller, this.authController});

  @override
  State<ProgramlarView> createState() => _ProgramlarViewState();
}

class _ProgramlarViewState extends State<ProgramlarView> {
  late final ProgramlarController _controller;
  late final bool _internalController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = ProgramlarController();
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

  void _handleProgramManage(ProgramModel program) {
    final role = widget.authController?.currentRole;
    if (role != null && !PermissionService.canManagePrograms(role)) {
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
                  PermissionService.getDenialReason('manage_programs'),
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

    final success = _controller.programDuzenle(program.id, currentRole: role);
    if (!success) return;

    final colors = context.spaceColors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${program.ad} için kurum yönetim konsolu aktif edildi.'),
        backgroundColor: colors.ascensionLime,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTakvimToggle(ProgramModel program) {
    _controller.takvimeEkle(program.id);
    final eklendi = !program.takvimeEklendi;
    final colors = context.spaceColors;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              eklendi
                  ? Icons.event_available_rounded
                  : Icons.event_busy_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                eklendi
                    ? '${program.ad} son başvuru tarihi (${program.sonBasvuruTarihi}) takviminize eklendi!'
                    : '${program.ad} takviminizden kaldırıldı.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: eklendi ? colors.ascensionLime : colors.rocketFlame,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProgramDetail(BuildContext context, ProgramModel program) {
    final colors = context.spaceColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.isDark ? colors.nightBlue : colors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  program.ad,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  program.kurum,
                  style: TextStyle(
                    color: colors.nebulaCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Başvuru Adımları',
                  style: TextStyle(
                    color: colors.rocketFlame,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...program.basvuruAdimlari.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: colors.rocketFlame.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.rocketFlame,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _handleTakvimToggle(program);
                    },
                    icon: Icon(
                      program.takvimeEklendi
                          ? Icons.event_busy_rounded
                          : Icons.calendar_today_rounded,
                      size: 16,
                    ),
                    label: Text(
                      program.takvimeEklendi
                          ? 'Takvimden Çıkar'
                          : AppStrings.takvimeEkle,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.rocketFlame,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _handleProgramManage(program);
                    },
                    icon: const Icon(Icons.edit_note_rounded, size: 16),
                    label: const Text('Programı Yönet / Düzenle (Kurum)'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                title: 'Destek ve Programlar',
                subtitle: 'Hibe, kuluçka ve hızlandırıcı destek fırsatları',
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          SliverToBoxAdapter(child: _buildSearchAndFilter()),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<ProgramKategori>(
              valueListenable: _controller.seciliKategori,
              builder: (context, kat, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: SectionHeader(
                    title: kat.baslik,
                    subtitle: 'Girişimciler için açık çağrılar ve hibeler',
                  ),
                );
              },
            ),
          ),
          _buildProgramList(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return ValueListenableBuilder<ProgramKategori>(
      valueListenable: _controller.seciliKategori,
      builder: (context, secili, _) {
        final colors = context.spaceColors;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: ProgramKategori.values.map((kat) {
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

  Widget _buildSearchAndFilter() {
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
              hintText: 'Program adı, kurum veya hibe ara...',
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
          _buildStatusFilterChips(),
        ],
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final colors = context.spaceColors;
    return ValueListenableBuilder<ProgramDurum?>(
      valueListenable: _controller.seciliDurum,
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
                onSelected: (_) => _controller.durumSec(null),
              ),
              const SizedBox(width: 6),
              ...ProgramDurum.values.map(
                (durum) {
                  final isSelected = secili == durum;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(durum.baslik),
                      selected: isSelected,
                      selectedColor:
                          colors.ascensionLime.withValues(alpha: 0.25),
                      checkmarkColor: colors.ascensionLime,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colors.ascensionLime
                            : colors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color:
                            isSelected ? colors.ascensionLime : colors.border,
                      ),
                      onSelected: (selected) {
                        _controller.durumSec(selected ? durum : null);
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

  Widget _buildProgramList() {
    return ValueListenableBuilder<List<ProgramModel>>(
      valueListenable: _controller.gorunenProgramlar,
      builder: (context, liste, _) {
        final colors = context.spaceColors;

        if (liste.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_off_rounded,
                      size: 64,
                      color: colors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kriterlere Uygun Program Bulunamadı',
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
              final program = liste[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProgramCard(
                  program: program,
                  onTakvimToggle: () => _handleTakvimToggle(program),
                  onDetay: () => _showProgramDetail(context, program),
                ),
              );
            }, childCount: liste.length),
          ),
        );
      },
    );
  }
}
