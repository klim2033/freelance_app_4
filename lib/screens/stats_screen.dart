import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Статистика'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'День'),
              Tab(text: 'Неделя'),
              Tab(text: 'Месяц'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StatsPeriodView(period: 'День'),
            _StatsPeriodView(period: 'Неделя'),
            _StatsPeriodView(period: 'Месяц'),
          ],
        ),
      ),
    );
  }
}

class _StatsPeriodView extends StatelessWidget {
  final String period;

  const _StatsPeriodView({required this.period});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _StatsCard(
          title: 'Калории',
          value: '2100',
          unit: 'ккал',
          progress: 0.7,
        ),
        _StatsCard(
          title: 'Белки',
          value: '60',
          unit: 'г',
          progress: 0.6,
        ),
        _StatsCard(
          title: 'Жиры',
          value: '45',
          unit: 'г',
          progress: 0.5,
        ),
        _StatsCard(
          title: 'Углеводы',
          value: '250',
          unit: 'г',
          progress: 0.8,
        ),
        _StatsCard(
          title: 'Вода',
          value: '1.5',
          unit: 'л',
          progress: 0.75,
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final double progress;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('$value $unit', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
