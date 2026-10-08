import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoginRingsPainter extends CustomPainter {
  const LoginRingsPainter({required this.color, required this.step, required this.stroke});

  final Color color;
  final double step;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width, size.height);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    for (var radius = step - stroke / 2; radius <= maxRadius; radius += step) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(LoginRingsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.step != step || oldDelegate.stroke != stroke;
}
