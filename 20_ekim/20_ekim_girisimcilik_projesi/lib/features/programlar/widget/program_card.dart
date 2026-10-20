import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTakvimToggle;
  final VoidCallback onDetay;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onTakvimToggle,
    required this.onDetay,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return GlowCard(
      glowColor:
          program.takvimeEklendi ? colors.ascensionLime : colors.glowBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colors, textTheme),
          const SizedBox(height: 8),
          Text(
            program.aciklama,
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 10),
          _buildSupportAmountBadge(colors),
          const SizedBox(height: 10),
          _buildDeadlineAndStatus(colors),
          const SizedBox(height: 10),
          _buildRequirementsList(colors),
          const SizedBox(height: 12),
          _buildActionButtons(colors),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic colors, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.rocketFlame.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.workspace_premium_rounded,
            color: colors.rocketFlame,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                program.ad,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                program.kurum,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.nebulaCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportAmountBadge(dynamic colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.monetization_on_outlined,
            size: 16,
            color: colors.ascensionLime,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              program.destekTutari,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors.ascensionLime,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineAndStatus(dynamic colors) {
    Color statusColor;
    switch (program.durum) {
      case ProgramDurum.acik:
        statusColor = colors.ascensionLime;
        break;
      case ProgramDurum.yakinda:
        statusColor = colors.nebulaCyan;
        break;
      case ProgramDurum.kapandi:
        statusColor = colors.textMuted;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: colors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              'Son: ${program.sonBasvuruTarihi}',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            program.durum.baslik,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsList(dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: program.uygunlukSartlari.take(2).map((sart) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 13,
                color: colors.nebulaCyan,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sart,
                  style: TextStyle(fontSize: 11, color: colors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(dynamic colors) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onTakvimToggle,
            icon: Icon(
              program.takvimeEklendi
                  ? Icons.event_available_rounded
                  : Icons.calendar_month_rounded,
              size: 16,
            ),
            label: Text(
              program.takvimeEklendi ? 'Takvimde' : AppStrings.takvimeEkle,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDetay,
            icon: const Icon(Icons.info_outline_rounded, size: 16),
            label: const Text(
              AppStrings.basvuruBilgisi,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
