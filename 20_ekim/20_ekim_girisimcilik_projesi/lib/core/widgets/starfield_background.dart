import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Derin uzay yıldız alanı arka planı (CustomPainter).
/// Performans için RepaintBoundary ile izole edilmiştir.
class StarfieldBackground extends StatelessWidget {
  final Widget? child;
  final int starCount;

  const StarfieldBackground({super.key, this.child, this.starCount = 70});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _StarfieldPainter(starCount: starCount, isDark: isDark),
        child: child,
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final int starCount;
  final bool isDark;

  // Deterministik yıldız koordinatları için sabit seed
  static final List<math.Point<double>> _points = List.generate(120, (i) {
    final rand = math.Random(i * 37 + 11);
    return math.Point(rand.nextDouble(), rand.nextDouble());
  });

  _StarfieldPainter({required this.starCount, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      return; // Açık temada temiz şafak görünümü için yıldız çizilmez
    }

    final starPaint = Paint()..color = Colors.white;
    final cyanPaint = Paint()..color = const Color(0xFF22D3EE);
    final orangePaint = Paint()..color = const Color(0xFFFF6B2C);

    final count = math.min(starCount, _points.length);
    for (int i = 0; i < count; i++) {
      final pt = _points[i];
      final dx = pt.x * size.width;
      final dy = pt.y * size.height;

      final radius = (i % 7 == 0) ? 1.6 : (i % 3 == 0 ? 1.1 : 0.7);
      final alpha = (i % 5 == 0) ? 0.8 : (i % 2 == 0 ? 0.45 : 0.25);

      Paint currentPaint;
      if (i % 13 == 0) {
        currentPaint = cyanPaint
          ..color = cyanPaint.color.withValues(alpha: alpha);
      } else if (i % 17 == 0) {
        currentPaint = orangePaint
          ..color = orangePaint.color.withValues(alpha: alpha);
      } else {
        currentPaint = starPaint
          ..color = starPaint.color.withValues(alpha: alpha);
      }

      canvas.drawCircle(Offset(dx, dy), radius, currentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.starCount != starCount;
  }
}
