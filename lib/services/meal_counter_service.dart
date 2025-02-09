import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealCounterService extends ChangeNotifier {
  static const String _mealsCountKey = 'meals_count';
  static const String _lastUpdateKey = 'meal_last_update';
  static const int dailyMealGoal = 3;

  int _dailyMealsCount = 0;
  DateTime _lastUpdate = DateTime.now();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  MealCounterService() {
    _loadData();
  }

  int get dailyMealsCount => _dailyMealsCount;
  int get remainingMeals => dailyMealGoal - _dailyMealsCount;
  double get progressPercentage =>
      (_dailyMealsCount / dailyMealGoal).clamp(0.0, 1.0);

  Future<void> _loadData() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }

    final lastUpdateStr = _prefs.getString(_lastUpdateKey);
    if (lastUpdateStr != null) {
      final lastUpdate = DateTime.parse(lastUpdateStr);
      if (!_isSameDay(lastUpdate, DateTime.now())) {
        await _resetDaily();
      } else {
        _dailyMealsCount = _prefs.getInt(_mealsCountKey) ?? 0;
        _lastUpdate = lastUpdate;
      }
    }
    notifyListeners();
  }

  Future<void> _resetDaily() async {
    _dailyMealsCount = 0;
    _lastUpdate = DateTime.now();
    await _saveData();
  }

  Future<void> _saveData() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
    await _prefs.setInt(_mealsCountKey, _dailyMealsCount);
    await _prefs.setString(_lastUpdateKey, _lastUpdate.toIso8601String());
  }

  Future<void> addMeal() async {
    if (!_isSameDay(_lastUpdate, DateTime.now())) {
      await _resetDaily();
    }
    if (_dailyMealsCount < dailyMealGoal) {
      _dailyMealsCount++;
      _lastUpdate = DateTime.now();
      await _saveData();
      notifyListeners();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
