import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Bölüm başlıklarını ve varsa sağ aksiyon bağlantısını gösteren bileşen.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    String? actionText,
    String? actionLabel,
    VoidCallback? onActionTap,
    VoidCallback? onActionPressed,
  }) : actionText = actionLabel ?? actionText,
       onActionTap = onActionPressed ?? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
