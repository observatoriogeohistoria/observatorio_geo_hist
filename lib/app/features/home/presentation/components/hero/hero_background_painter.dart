import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HeroBackground extends StatelessWidget {
  const HeroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(painter: HeroBackgroundPainter(), size: Size.infinite),
        ),
      ),
    );
  }
}

class HeroBackgroundPainter extends CustomPainter {
  const HeroBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final stroke = AppTheme.dimensions.stroke.small;
    final rect = Offset.zero & size;

    canvas.saveLayer(rect, Paint());

    _paintRings(
      canvas,
      size,
      center: _at(size, components.heroRingAccentCenter),
      step: components.heroRingAccentStep,
      color: colors.accent.withValues(alpha: components.heroRingAccentOpacity),
      stroke: stroke,
    );
    _paintRings(
      canvas,
      size,
      center: _at(size, components.heroRingInkCenter),
      step: components.heroRingInkStep,
      color: colors.ink.withValues(alpha: components.heroRingInkOpacity),
      stroke: stroke,
    );

    final fade = Paint()
      ..blendMode = BlendMode.dstIn
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colors.ink, colors.ink, colors.ink.withValues(alpha: 0)],
        stops: [0, components.heroRingFadeStart, 1],
      ).createShader(rect);
    canvas.drawRect(rect, fade);

    canvas.restore();
  }

  Offset _at(Size size, Offset fraction) => Offset(size.width * fraction.dx, size.height * fraction.dy);

  void _paintRings(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double step,
    required Color color,
    required double stroke,
  }) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    final farthest = corners.map((corner) => (corner - center).distance).reduce(math.max);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = color;

    for (var radius = step - stroke / 2; radius <= farthest; radius += step) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(HeroBackgroundPainter oldDelegate) => false;
}
