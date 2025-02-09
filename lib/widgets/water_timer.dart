import 'package:flutter/material.dart';
import 'dart:async';

class WaterTimer extends StatefulWidget {
  final int intervalMinutes;
  final VoidCallback onTimerComplete;

  const WaterTimer({
    super.key,
    required this.intervalMinutes,
    required this.onTimerComplete,
  });

  @override
  State<WaterTimer> createState() => _WaterTimerState();
}

class _WaterTimerState extends State<WaterTimer> {
  late Timer _timer;
  late DateTime _endTime;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _endTime = DateTime.now().add(Duration(minutes: widget.intervalMinutes));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(_endTime)) {
        widget.onTimerComplete();
        _endTime = now.add(Duration(minutes: widget.intervalMinutes));
      }
      if (mounted) {
        setState(() {
          _remainingTime = _endTime.difference(now);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Следующее напоминание через:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Интервал: ${widget.intervalMinutes} мин',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
