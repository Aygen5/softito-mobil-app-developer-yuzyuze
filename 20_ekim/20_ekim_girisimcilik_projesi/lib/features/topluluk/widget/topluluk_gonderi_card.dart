import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/topluluk_model.dart';
import 'topluluk_yanit_item.dart';

class ToplulukGonderiCard extends StatelessWidget {
  final ToplulukGonderiModel gonderi;
  final bool paylasabilir;
  final VoidCallback onBegeni;
  final VoidCallback onYanitla;

  const ToplulukGonderiCard({
    super.key,
    required this.gonderi,
    required this.paylasabilir,
    required this.onBegeni,
    required this.onYanitla,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return GlowCard(
      glowColor: gonderi.begenildi ? colors.rocketFlame : colors.glowBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorRow(colors, textTheme),
          const SizedBox(height: 10),
          Text(
            gonderi.metin,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionRow(colors),
          if (gonderi.yanitlar.isNotEmpty) ...[
            const Divider(height: 16),
            ...gonderi.yanitlar.map((y) => ToplulukYanitItem(yanit: y)),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthorRow(dynamic colors, TextTheme textTheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: colors.rocketFlame.withValues(alpha: 0.15),
          child: Text(
            gonderi.yazar.isNotEmpty ? gonderi.yazar[0] : 'G',
            style: TextStyle(
              color: colors.rocketFlame,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gonderi.yazar,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                gonderi.girisimAdi,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.nebulaCyan,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(dynamic colors) {
    return Row(
      children: [
        InkWell(
          onTap: paylasabilir ? onBegeni : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  gonderi.begenildi
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18,
                  color:
                      gonderi.begenildi ? colors.rocketFlame : colors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  '${gonderi.begeniSayisi}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: gonderi.begenildi
                        ? colors.rocketFlame
                        : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: paylasabilir ? onYanitla : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: colors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  '${gonderi.yanitlar.length} Yanıt',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
