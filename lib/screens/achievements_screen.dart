import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Достижения'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _AchievementCard(
            title: 'Первые шаги',
            description: 'Заполните профиль',
            icon: Icons.person,
            isCompleted: true,
          ),
          _AchievementCard(
            title: 'Водный баланс',
            description: 'Достигните цели по воде 7 дней подряд',
            icon: Icons.water_drop,
            isCompleted: false,
            progress: 0.4,
          ),
          _AchievementCard(
            title: 'Шеф-повар',
            description: 'Добавьте 5 рецептов',
            icon: Icons.restaurant,
            isCompleted: false,
            progress: 0.6,
          ),
          _AchievementCard(
            title: 'Правильное питание',
            description: 'Соблюдайте норму калорий 30 дней',
            icon: Icons.trending_up,
            isCompleted: false,
            progress: 0.2,
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final double? progress;

  const _AchievementCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isCompleted,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: isCompleted ? Colors.green : Colors.grey,
          size: 32,
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            if (progress != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
            ],
          ],
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
      ),
    );
  }
}
