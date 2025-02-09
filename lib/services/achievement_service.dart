import 'package:flutter/foundation.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool hasProgress;
  final double progress;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.hasProgress = false,
    this.progress = 0.0,
    this.isUnlocked = false,
  });
}

class AchievementService extends ChangeNotifier {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_water',
      title: 'Первый глоток',
      description: 'Запишите свое первое потребление воды',
      isUnlocked: false,
    ),
    Achievement(
      id: 'water_streak',
      title: 'Водный марафон',
      description: 'Достигните цели по воде 7 дней подряд',
      hasProgress: true,
      progress: 0.3,
      isUnlocked: false,
    ),
    Achievement(
      id: 'water_master',
      title: 'Мастер гидратации',
      description: 'Достигните цели по воде 30 дней подряд',
      hasProgress: true,
      progress: 0.1,
      isUnlocked: false,
    ),
    Achievement(
      id: 'perfect_day',
      title: 'Идеальный день',
      description: 'Достигните всех целей за один день',
      isUnlocked: true,
    ),
  ];

  List<Achievement> get achievements => List.unmodifiable(_achievements);

  Future<void> unlockAchievement(String id) async {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final achievement = _achievements[index];
      _achievements[index] = Achievement(
        id: achievement.id,
        title: achievement.title,
        description: achievement.description,
        hasProgress: achievement.hasProgress,
        progress: 1.0,
        isUnlocked: true,
      );
      notifyListeners();
      // Здесь можно добавить сохранение в SharedPreferences
    }
  }

  Future<void> updateProgress(String id, double progress) async {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final achievement = _achievements[index];
      if (achievement.hasProgress) {
        _achievements[index] = Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          hasProgress: true,
          progress: progress.clamp(0.0, 1.0),
          isUnlocked: progress >= 1.0,
        );
        notifyListeners();
        // Здесь можно добавить сохранение в SharedPreferences
      }
    }
  }
}
