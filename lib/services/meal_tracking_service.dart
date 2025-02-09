import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_record.dart';

class MealTrackingService extends ChangeNotifier {
  static const String _storageKey = 'meal_records';
  final SharedPreferences _prefs;
  List<MealRecord> _meals = [];

  MealTrackingService(this._prefs) {
    _loadMeals();
  }

  List<MealRecord> get meals => _meals;

  List<MealRecord> getMealsForDate(DateTime date) {
    return _meals
        .where((meal) =>
            meal.date.year == date.year &&
            meal.date.month == date.month &&
            meal.date.day == date.day)
        .toList();
  }

  Future<void> addMeal(MealRecord meal) async {
    _meals.add(meal);
    await _saveMeals();
    notifyListeners();
  }

  Future<void> removeMeal(String id) async {
    _meals.removeWhere((meal) => meal.id == id);
    await _saveMeals();
    notifyListeners();
  }

  Future<void> updateMeal(MealRecord updatedMeal) async {
    final index = _meals.indexWhere((meal) => meal.id == updatedMeal.id);
    if (index != -1) {
      _meals[index] = updatedMeal;
      await _saveMeals();
      notifyListeners();
    }
  }

  void _loadMeals() {
    final String? mealsJson = _prefs.getString(_storageKey);
    if (mealsJson != null) {
      final List<dynamic> decoded = json.decode(mealsJson);
      _meals = decoded.map((item) => MealRecord.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveMeals() async {
    final String encoded = json.encode(_meals.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }

  bool hasMealsOnDate(DateTime date) {
    return _meals.any((meal) =>
        meal.date.year == date.year &&
        meal.date.month == date.month &&
        meal.date.day == date.day);
  }

  Map<MealType, MealRecord?> getMealsByTypeForDate(DateTime date) {
    final mealsOnDate = getMealsForDate(date);
    return {
      MealType.breakfast: mealsOnDate.firstWhere(
        (m) => m.type == MealType.breakfast,
        orElse: () => MealRecord(
          id: '',
          date: date,
          type: MealType.breakfast,
          description: '',
          calories: 0,
          foods: [],
        ),
      ),
      MealType.lunch: mealsOnDate.firstWhere(
        (m) => m.type == MealType.lunch,
        orElse: () => MealRecord(
          id: '',
          date: date,
          type: MealType.lunch,
          description: '',
          calories: 0,
          foods: [],
        ),
      ),
      MealType.dinner: mealsOnDate.firstWhere(
        (m) => m.type == MealType.dinner,
        orElse: () => MealRecord(
          id: '',
          date: date,
          type: MealType.dinner,
          description: '',
          calories: 0,
          foods: [],
        ),
      ),
      MealType.snack: mealsOnDate.firstWhere(
        (m) => m.type == MealType.snack,
        orElse: () => MealRecord(
          id: '',
          date: date,
          type: MealType.snack,
          description: '',
          calories: 0,
          foods: [],
        ),
      ),
    };
  }
}
