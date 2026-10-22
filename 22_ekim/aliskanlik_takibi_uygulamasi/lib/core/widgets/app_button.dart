import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum AppButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isTrailingIcon;
  final AppButtonType type;
  final double height;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isTrailingIcon = true,
    this.type = AppButtonType.primary,
    this.height = 56,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;

    switch (type) {
      case AppButtonType.primary:
        bg = AppColors.tertiaryContainer;
        fg = AppColors.onTertiaryContainer;
        break;
      case AppButtonType.secondary:
        bg = AppColors.surfaceContainer;
        fg = AppColors.onSurface;
        break;
      case AppButtonType.outline:
        bg = Colors.transparent;
        fg = AppColors.onSurface;
        border = Border.all(color: AppColors.outlineVariant);
        break;
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: bg,
        borderRadius: AppRadius.lgRadius,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadius.lgRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.lgRadius,
              border: border,
              boxShadow: type == AppButtonType.primary
                  ? [
                      BoxShadow(
                        color: AppColors.tertiaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: fg,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null && !isTrailingIcon) ...[
                          Icon(icon, color: fg, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: AppTypography.headlineSmall.copyWith(
                            color: fg,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (icon != null && isTrailingIcon) ...[
                          const SizedBox(width: 8),
                          Icon(icon, color: fg, size: 20),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
