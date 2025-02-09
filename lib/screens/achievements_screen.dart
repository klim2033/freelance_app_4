import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Достижения'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<AchievementService>(
        builder: (context, achievementService, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: achievementService.achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievementService.achievements[index];
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _slideController,
                  curve: Interval(
                    index * 0.1,
                    1.0,
                    curve: Curves.easeOutCubic,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _AchievementCard(
                    achievement: achievement,
                    scaleAnimation: _scaleController,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        },
        tooltip: 'На главную',
        child: const Icon(Icons.home),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final AnimationController scaleAnimation;

  const _AchievementCard({
    required this.achievement,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: scaleAnimation,
        curve: Curves.easeOutBack,
      ),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () => _showAchievementDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      achievement.isUnlocked
                          ? Icons.emoji_events
                          : Icons.lock_outline,
                      size: 32,
                      color:
                          achievement.isUnlocked ? Colors.amber : Colors.grey,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement.description,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (achievement.hasProgress) ...[
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: achievement.progress,
                    ),
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                achievement.isUnlocked
                                    ? Colors.green
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(value * 100).toInt()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 16),
            if (achievement.hasProgress) ...[
              const Text(
                'Прогресс:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: achievement.progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  achievement.isUnlocked
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text('${(achievement.progress * 100).toInt()}%'),
            ],
            const SizedBox(height: 16),
            Text(
              achievement.isUnlocked
                  ? 'Достижение разблокировано!'
                  : 'Продолжайте стараться!',
              style: TextStyle(
                color: achievement.isUnlocked ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
