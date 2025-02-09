import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../models/daily_stats.dart';
import 'database_service.dart';

class DailyStatsService extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  DailyStats? _currentStats;

  DailyStats get currentStats =>
      _currentStats ??
      DailyStats(
        steps: 0,
        calories: 0,
        distance: 0,
        date: DateTime.now(),
      );

  Future<void> loadTodayStats() async {
    final today = DateTime.now();
    final db = await _db.database;
    final result = await db.query(
      'daily_stats',
      where: 'date = ?',
      whereArgs: [today.toIso8601String().split('T')[0]],
    );

    if (result.isNotEmpty) {
      _currentStats = DailyStats.fromMap(result.first);
    } else {
      _currentStats = DailyStats(
        steps: 0,
        calories: 0,
        distance: 0,
        date: today,
      );
      await _saveStats(_currentStats!);
    }
    notifyListeners();
  }

  Future<void> updateSteps(int steps) async {
    if (_currentStats == null) return;

    final calories = _calculateCalories(steps);
    final distance = _calculateDistance(steps);

    _currentStats = _currentStats!.copyWith(
      steps: steps,
      calories: calories,
      distance: distance,
    );

    await _saveStats(_currentStats!);
    notifyListeners();
  }

  Future<void> _saveStats(DailyStats stats) async {
    final db = await _db.database;
    await db.insert(
      'daily_stats',
      stats.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int _calculateCalories(int steps) {
    // Average calorie burn per step (can be adjusted based on user profile)
    const caloriesPerStep = 0.04;
    return (steps * caloriesPerStep).round();
  }

  int _calculateDistance(int steps) {
    // Average step length in meters (can be adjusted based on user profile)
    const stepLength = 0.762; // ~30 inches
    return (steps * stepLength).round();
  }
}
