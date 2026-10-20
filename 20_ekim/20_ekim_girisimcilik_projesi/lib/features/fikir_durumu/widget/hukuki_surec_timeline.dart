import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/fikir_durumu_model.dart';

class HukukiSurecTimeline extends StatelessWidget {
  final List<HukukiSurecAdimi> adimlar;

  const HukukiSurecTimeline({super.key, required this.adimlar});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDark ? colors.nightBlue : colors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: colors.rocketFlame, size: 20),
              const SizedBox(width: 8),
              Text(
                'T.C. Mevzuatına Uygun Şirketleşme Yol Haritası',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...adimlar.map((adim) => _buildTimelineStep(context, adim, colors)),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context,
    HukukiSurecAdimi adim,
    dynamic colors,
  ) {
    Color iconColor;
    IconData icon;
    String durumYazisi;

    switch (adim.durum) {
      case HukukiAdimDurumu.tamamlandi:
        iconColor = colors.ascensionLime;
        icon = Icons.check_circle_rounded;
        durumYazisi = 'Tamamlandı';
        break;
      case HukukiAdimDurumu.devamEdiyor:
        iconColor = colors.nebulaCyan;
        icon = Icons.pending_rounded;
        durumYazisi = 'Yürütülüyor';
        break;
      case HukukiAdimDurumu.sirada:
        iconColor = colors.textMuted;
        icon = Icons.radio_button_unchecked_rounded;
        durumYazisi = 'Sırada';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: iconColor, size: 20),
              if (adim.sira < adimlar.length)
                Container(width: 2, height: 32, color: colors.border),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${adim.sira}. ${adim.baslik}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      durumYazisi,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  adim.aciklama,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
