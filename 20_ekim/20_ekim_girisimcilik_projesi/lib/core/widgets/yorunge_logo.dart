import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class YorungeLogo extends StatefulWidget {
  final double size;
  final bool isAnimated;

  const YorungeLogo({
    super.key,
    this.size = 80,
    this.isAnimated = true,
  });

  @override
  State<YorungeLogo> createState() => _YorungeLogoState();
}

class _YorungeLogoState extends State<YorungeLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (widget.isAnimated) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _YorungeLogoPainter(
            animationValue: _controller.value,
            primaryColor: colors.rocketFlame,
            secondaryColor: colors.nebulaCyan,
            tertiaryColor: colors.starPurple,
            glowColor: colors.rocketFlame.withValues(alpha: 0.35),
          ),
        );
      },
    );
  }
}

class _YorungeLogoPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color glowColor;

  _YorungeLogoPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Arka plan orbital parlama
    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius * 0.75, glowPaint);

    // 2. Dış Yörünge Halkası (Eğik elips)
    final orbitPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          primaryColor.withValues(alpha: 0.1),
          secondaryColor,
          tertiaryColor,
          primaryColor.withValues(alpha: 0.1),
        ],
        transform: GradientRotation(animationValue * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.95,
        height: size.height * 0.45,
      ),
      orbitPaint,
    );

    // Yörünge üzerindeki uydu/nokta
    final angle = animationValue * 2 * math.pi;
    final dotX = (size.width * 0.95 / 2) * math.cos(angle);
    final dotY = (size.height * 0.45 / 2) * math.sin(angle);
    final dotPaint = Paint()..color = secondaryColor;
    canvas.drawCircle(Offset(dotX, dotY), size.width * 0.04, dotPaint);

    canvas.restore();

    // 3. İkinci Karşıt Yörünge (Daha ince nebula halkası)
    final innerOrbitPaint = Paint()
      ..color = tertiaryColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.8,
        height: size.height * 0.38,
      ),
      innerOrbitPaint,
    );
    canvas.restore();

    // 4. Merkezdeki Gezegen / Çekirdek (Gradyanlı Küre)
    final sphereShader = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 0.85,
      colors: [
        primaryColor,
        primaryColor.withValues(alpha: 0.85),
        const Color(0xFF1E1035),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius * 0.42));

    final spherePaint = Paint()..shader = sphereShader;
    canvas.drawCircle(center, radius * 0.42, spherePaint);

    // 5. Roket İkonu / Yükseliş Vurgusu
    final rocketPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final rSize = radius * 0.45;
    final rx = center.dx;
    final ry = center.dy - rSize * 0.15;

    // Roket burnu
    path.moveTo(rx, ry - rSize * 0.6);
    path.quadraticBezierTo(
      rx + rSize * 0.35,
      ry - rSize * 0.1,
      rx + rSize * 0.25,
      ry + rSize * 0.45,
    );
    path.lineTo(rx - rSize * 0.25, ry + rSize * 0.45);
    path.quadraticBezierTo(
      rx - rSize * 0.35,
      ry - rSize * 0.1,
      rx,
      ry - rSize * 0.6,
    );
    path.close();
    canvas.drawPath(path, rocketPaint);

    // Roket ateşi (Alev kuyruğu)
    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor,
          const Color(0xFFFFCC00),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(
            rx - rSize * 0.15, ry + rSize * 0.45, rSize * 0.3, rSize * 0.4),
      );

    final flamePath = Path()
      ..moveTo(rx - rSize * 0.15, ry + rSize * 0.45)
      ..lineTo(rx, ry + rSize * 0.8)
      ..lineTo(rx + rSize * 0.15, ry + rSize * 0.45)
      ..close();
    canvas.drawPath(flamePath, flamePaint);
  }

  @override
  bool shouldRepaint(covariant _YorungeLogoPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.primaryColor != primaryColor;
  }
}
