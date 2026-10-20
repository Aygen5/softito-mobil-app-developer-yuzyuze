import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/mentor_model.dart';

class MentorCard extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onEslesmeIste;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onEslesmeIste,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return GlowCard(
      glowColor: mentor.durum == EslesmeDurumu.beklemede
          ? colors.nebulaCyan
          : colors.glowBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colors, textTheme),
          const SizedBox(height: 10),
          Text(
            mentor.aciklama,
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          _buildSpecialties(colors),
          const SizedBox(height: 12),
          _buildActionButton(colors),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    dynamic colors,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: colors.rocketFlame.withValues(alpha: 0.15),
          child: Text(
            mentor.ad.isNotEmpty ? mentor.ad[0] : 'M',
            style: TextStyle(
              color: colors.rocketFlame,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mentor.ad,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${mentor.unvan} • ${mentor.sirket}',
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildRatingBadge(colors),
      ],
    );
  }

  Widget _buildRatingBadge(dynamic colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.ascensionLime.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14, color: colors.ascensionLime),
          const SizedBox(width: 4),
          Text(
            mentor.puan.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.ascensionLime,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialties(dynamic colors) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: mentor.uzmanliklar
          .map(
            (u) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.surfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                u,
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActionButton(dynamic colors) {
    switch (mentor.durum) {
      case EslesmeDurumu.yok:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: mentor.musaitMi ? onEslesmeIste : null,
            icon: const Icon(Icons.rocket_launch_rounded, size: 16),
            label: Text(
              mentor.musaitMi ? AppStrings.eslesmeIste : 'Müsait Değil',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.rocketFlame,
              foregroundColor: Colors.white,
            ),
          ),
        );
      case EslesmeDurumu.beklemede:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.nebulaCyan.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.nebulaCyan.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_top_rounded,
                size: 16,
                color: colors.nebulaCyan,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.eslesmeBeklemede,
                style: TextStyle(
                  color: colors.nebulaCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      case EslesmeDurumu.eslesti:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.ascensionLime.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            AppStrings.eslesmeTamam,
            style: TextStyle(
              color: colors.ascensionLime,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}
