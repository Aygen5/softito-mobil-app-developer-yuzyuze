import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/fikir_durumu_model.dart';

class GelirDestekKarti extends StatelessWidget {
  final GelirDestekModel gelirDestegi;

  const GelirDestekKarti({super.key, required this.gelirDestegi});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;
    final yuzde = (gelirDestegi.ilerlemeOrani * 100).toInt();

    return GlowCard(
      glowColor: colors.ascensionLime,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.ascensionLime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  color: colors.ascensionLime,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.gelirDestekTaahhut,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colors.ascensionLime,
                      ),
                    ),
                    Text(
                      'Aylık Hedef: ${gelirDestegi.aylikHedefTl.toStringAsFixed(0)} ₺',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.ascensionLime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '%$yuzde',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.ascensionLime,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: gelirDestegi.ilerlemeOrani,
              minHeight: 8,
              backgroundColor: colors.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(colors.ascensionLime),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mevcut Hak Ediş: ${gelirDestegi.gerceklesenTl.toStringAsFixed(0)} ₺',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                'Bitiş: ${gelirDestegi.taahhutBitisTarihi}',
                style: TextStyle(fontSize: 11, color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            gelirDestegi.aciklama,
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
