import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int intervalMinutes;
  final VoidCallback? onTimerComplete;

  const CountdownTimer({
    super.key,
    required this.intervalMinutes,
    this.onTimerComplete,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DateTime _endTime;
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _resetTimer();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _resetTimer() {
    _endTime = DateTime.now().add(Duration(minutes: widget.intervalMinutes));
    _updateRemainingTime();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateRemainingTime();
      }
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    if (now.isAfter(_endTime)) {
      widget.onTimerComplete?.call();
      _resetTimer();
    } else {
      setState(() {
        _remainingTime = _endTime.difference(now);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 8,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: CustomPaint(
              painter: TimerPainter(
                animation: _controller,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                color: Theme.of(context).primaryColor,
                progress:
                    _remainingTime.inSeconds / (widget.intervalMinutes * 60),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'до напоминания',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;
  final double progress;

  TimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;

    double progressAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Offset.zero & size,
      -math.pi / 2,
      progressAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor ||
        progress != old.progress;
  }
}
