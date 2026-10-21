import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// StajTakip ortak kart bileşeni.
/// Tutarlı padding, radius, kenarlık ve tıklanabilir ise ripple efekti sağlar.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double elevation;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.borderRadius = 16,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(color: borderColor, width: 1),
    );

    final content = Padding(padding: padding, child: child);

    if (onTap != null) {
      return Container(
        margin: margin,
        child: Material(
          color: backgroundColor,
          shape: shape,
          elevation: elevation,
          clipBehavior: Clip.antiAlias,
          child: InkWell(onTap: onTap, child: content),
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: elevation * 4,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null,
      ),
      child: content,
    );
  }
}
