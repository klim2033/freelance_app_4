import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _dailyGoalKey = 'daily_calorie_goal';
  static const String _waterReminderKey = 'water_reminder_interval';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  bool get notificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  int get dailyCalorieGoal => _prefs.getInt(_dailyGoalKey) ?? 2000;
  int get waterReminderInterval => _prefs.getInt(_waterReminderKey) ?? 30;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setDailyCalorieGoal(int value) async {
    await _prefs.setInt(_dailyGoalKey, value);
    notifyListeners();
  }

  Future<void> setWaterReminderInterval(int minutes) async {
    await _prefs.setInt(_waterReminderKey, minutes);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await _prefs.remove(_notificationsKey);
    await _prefs.remove(_dailyGoalKey);
    await _prefs.remove(_waterReminderKey);
    notifyListeners();
  }
}
