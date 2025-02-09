import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveClipper extends CustomClipper<Path> {
  final double animation;
  final double waveHeight;

  WaveClipper(this.animation, {this.waveHeight = 20});

  @override
  Path getClip(Size size) {
    final path = Path();
    final y = size.height * (1 - animation);

    final firstWaveControlPoint = size.width * 0.25;
    final secondWaveControlPoint = size.width * 0.75;

    path.moveTo(0, y);
    path.cubicTo(
      firstWaveControlPoint,
      y - waveHeight * math.sin(animation * math.pi),
      secondWaveControlPoint,
      y + waveHeight * math.sin(animation * math.pi),
      size.width,
      y,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => true;
}
