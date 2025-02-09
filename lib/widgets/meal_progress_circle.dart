import 'package:flutter/material.dart';
import 'dart:math' as math;

class MealProgressCircle extends StatelessWidget {
  final double progress;
  final int remainingMeals;
  final VoidCallback onTap;

  const MealProgressCircle({
    super.key,
    required this.progress,
    required this.remainingMeals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background circle
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
                // Progress circle
                CustomPaint(
                  painter: _ProgressPainter(
                    progress: value,
                    primaryColor: Theme.of(context).colorScheme.primary,
                    secondaryColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Container(),
                ),
                // Center content
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: -5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$remainingMeals',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'приемов пищи\nосталось',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _ProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final strokeWidth = 12.0;

    // Create gradient
    final gradient = SweepGradient(
      colors: [primaryColor, secondaryColor],
      stops: const [0.0, 1.0],
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      transform: GradientRotation(-math.pi / 2),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    paint.color = const Color(0xFFEEEEEE);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      paint,
    );

    // Draw progress arc with gradient
    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
