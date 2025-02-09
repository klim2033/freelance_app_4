import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'settings_service.dart';

class WaterService extends ChangeNotifier {
  static const String _waterAmountKey = 'water_amount';
  static const String _lastUpdateKey = 'last_update';
  static const String _customDailyGoalKey = 'custom_daily_goal';

  final SharedPreferences _prefs;
  final NotificationService _notificationService = NotificationService();
  SettingsService? _settingsService;

  double _dailyWaterAmount = 0;
  DateTime _lastUpdate = DateTime.now();
  // Default goal is 2000ml (2 liters)
  double _customDailyGoal = 2000.0;

  void initSettingsService(SettingsService settingsService) {
    _settingsService = settingsService;
    // Применяем текущие настройки интервала
    scheduleWaterReminder(_settingsService!.waterReminderInterval);

    // Подписываемся на изменения настроек
    _settingsService!.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    if (_settingsService != null) {
      scheduleWaterReminder(_settingsService!.waterReminderInterval);
    }
  }

  @override
  void dispose() {
    if (_settingsService != null) {
      _settingsService!.removeListener(_onSettingsChanged);
    }
    super.dispose();
  }

  WaterService(this._prefs) {
    _loadData();
  }

  double get dailyWaterAmount => _dailyWaterAmount;
  double get customDailyGoal => _customDailyGoal;
  double get progressPercentage =>
      (_dailyWaterAmount / _customDailyGoal).clamp(0.0, 1.0);

  Future<void> _loadData() async {
    _customDailyGoal = _prefs.getDouble(_customDailyGoalKey) ?? 2000.0;
    final lastUpdateStr = _prefs.getString(_lastUpdateKey);

    if (lastUpdateStr != null) {
      final lastUpdate = DateTime.parse(lastUpdateStr);
      if (!_isSameDay(lastUpdate, DateTime.now())) {
        await _resetDaily();
      } else {
        _dailyWaterAmount = _prefs.getDouble(_waterAmountKey) ?? 0;
        _lastUpdate = lastUpdate;
      }
    }
    notifyListeners();
  }

  Future<void> setCustomDailyGoal(double amount) async {
    _customDailyGoal = amount;
    await _prefs.setDouble(_customDailyGoalKey, amount);
    notifyListeners();
  }

  Future<void> scheduleWaterReminder(int intervalMinutes) async {
    await _notificationService.cancelAllNotifications();
    await _notificationService.scheduleWaterReminder(
      intervalMinutes: intervalMinutes,
    );
  }

  Future<void> _resetDaily() async {
    _dailyWaterAmount = 0;
    _lastUpdate = DateTime.now();
    await _saveData();
  }

  Future<void> _saveData() async {
    await _prefs.setDouble(_waterAmountKey, _dailyWaterAmount);
    await _prefs.setString(_lastUpdateKey, _lastUpdate.toIso8601String());
  }

  Future<void> addWater(int amount) async {
    if (!_isSameDay(_lastUpdate, DateTime.now())) {
      await _resetDaily();
    }
    _dailyWaterAmount += amount;
    _lastUpdate = DateTime.now();
    await _saveData();
    notifyListeners();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
