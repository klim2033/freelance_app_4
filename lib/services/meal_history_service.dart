import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_history.dart';

class MealHistoryService extends ChangeNotifier {
  static const String _storageKey = 'meal_history';
  final SharedPreferences _prefs;
  List<MealEntry> _meals = [];

  MealHistoryService(this._prefs) {
    _loadMeals();
  }

  List<MealEntry> get meals => _meals;

  List<MealEntry> getMealsForDate(DateTime date) {
    return _meals
        .where((meal) =>
            meal.date.year == date.year &&
            meal.date.month == date.month &&
            meal.date.day == date.day)
        .toList();
  }

  Future<void> addMeal(MealEntry meal) async {
    _meals.add(meal);
    await _saveMeals();
    notifyListeners();
  }

  Future<void> removeMeal(String id) async {
    _meals.removeWhere((meal) => meal.id == id);
    await _saveMeals();
    notifyListeners();
  }

  void _loadMeals() {
    final String? mealsJson = _prefs.getString(_storageKey);
    if (mealsJson != null) {
      final List<dynamic> decoded = json.decode(mealsJson);
      _meals = decoded.map((item) => MealEntry.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveMeals() async {
    final String encoded = json.encode(_meals.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }
}
