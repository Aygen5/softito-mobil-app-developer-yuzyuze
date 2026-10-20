import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/yatirimci_model.dart';

class YatirimciCard extends StatelessWidget {
  final YatirimciModel yatirimci;
  final VoidCallback onIletisim;

  const YatirimciCard({
    super.key,
    required this.yatirimci,
    required this.onIletisim,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return GlowCard(
      glowColor: yatirimci.iletisimTalebiGonderildi
          ? colors.ascensionLime
          : colors.glowBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colors, textTheme),
          const SizedBox(height: 8),
          Text(
            yatirimci.aciklama,
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 10),
          _buildTicketAndStageRow(colors),
          const SizedBox(height: 10),
          _buildSectorsWrap(colors),
          const SizedBox(height: 10),
          _buildPortfolioRow(colors, textTheme),
          const SizedBox(height: 12),
          _buildContactInfo(colors),
          const SizedBox(height: 12),
          _buildActionButton(colors),
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
            color: colors.nebulaCyan.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.business_center_rounded,
            color: colors.nebulaCyan,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                yatirimci.ad,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                yatirimci.kategori.baslik,
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketAndStageRow(dynamic colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.confirmation_num_outlined,
                size: 14,
                color: colors.rocketFlame,
              ),
              const SizedBox(width: 6),
              Text(
                yatirimci.biletAraligi,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.rocketFlame,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.stairs_rounded, size: 14, color: colors.nebulaCyan),
              const SizedBox(width: 6),
              Text(
                yatirimci.asama,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.nebulaCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectorsWrap(dynamic colors) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: yatirimci.sektorler
          .map(
            (s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.surfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                s,
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPortfolioRow(dynamic colors, TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Portföy: ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: colors.textMuted,
          ),
        ),
        Expanded(
          child: Text(
            yatirimci.portfoy.join(' • '),
            style: TextStyle(fontSize: 11, color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(dynamic colors) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _contactItem(Icons.email_outlined, yatirimci.eposta, colors),
          _contactItem(Icons.phone_outlined, yatirimci.telefon, colors),
          _contactItem(Icons.language_rounded, yatirimci.web, colors),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text, dynamic colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: colors.textMuted),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 85),
          child: Text(
            text.replaceFirst('https://', ''),
            style: TextStyle(fontSize: 10, color: colors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(dynamic colors) {
    if (yatirimci.iletisimTalebiGonderildi) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.ascensionLime.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'İletişim Talebi Gönderildi',
          style: TextStyle(
            color: colors.ascensionLime,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onIletisim,
        icon: const Icon(Icons.send_rounded, size: 16),
        label: const Text(AppStrings.iletisimeGec),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.rocketFlame,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
