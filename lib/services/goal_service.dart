import 'package:flutter/foundation.dart';
import '../models/goal.dart';
import 'database_service.dart';

class GoalService extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<Goal> _goals = [];

  List<Goal> get goals => List.unmodifiable(_goals);
  List<Goal> get activeGoals =>
      _goals.where((goal) => !goal.isCompleted).toList();

  Future<void> loadGoals() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    _goals = List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    final db = await _db.database;
    await db.insert('goals', goal.toMap());
    _goals.add(goal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await _db.database;
    await db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    final db = await _db.database;
    await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }

  Future<void> updateProgress(String goalId, double newValue) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final updatedGoal = goal.copyWith(
        current: newValue,
        isCompleted: newValue >= goal.target,
      );
      await updateGoal(updatedGoal);
    }
  }

  List<Goal> getGoalsByType(GoalType type) {
    return _goals.where((goal) => goal.type == type).toList();
  }

  List<Goal> getGoalsByPeriod(GoalPeriod period) {
    return _goals.where((goal) => goal.period == period).toList();
  }
}
