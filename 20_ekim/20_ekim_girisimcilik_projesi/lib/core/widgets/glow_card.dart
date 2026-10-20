import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Yörünge tasarım sistemine uygun ince parlama kenarlıklı, gradyan yüzeyli kart.
class GlowCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glowColor;
  final BorderRadius? borderRadius;

  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.glowColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isDark = context.isDark;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveGlow = glowColor ?? colors.glowBorder;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: [
          BoxShadow(
            color: effectiveGlow.withValues(alpha: isDark ? 0.22 : 0.08),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: effectiveRadius,
              color: isDark ? colors.nightBlue : colors.surfaceDark,
              border: Border.all(
                color: isDark
                    ? colors.border.withValues(alpha: 0.9)
                    : colors.border.withValues(alpha: 0.6),
                width: 1.0,
              ),
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.nightBlue,
                        colors.surfaceDark.withValues(alpha: 0.8),
                      ],
                    )
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
