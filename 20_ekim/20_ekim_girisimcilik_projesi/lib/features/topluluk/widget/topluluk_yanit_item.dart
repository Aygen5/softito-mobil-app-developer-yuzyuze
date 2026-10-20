import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/topluluk_model.dart';

class ToplulukYanitItem extends StatelessWidget {
  final ToplulukYanitModel yanit;

  const ToplulukYanitItem({super.key, required this.yanit});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: colors.nebulaCyan, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                yanit.yazar,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '• ${yanit.unvan}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            yanit.metin,
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
