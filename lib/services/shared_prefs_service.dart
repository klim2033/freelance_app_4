import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _waterIntakeKey = 'water_intake';
  static const String _achievementsKey = 'achievements';
  static const String _lastWaterResetKey = 'last_water_reset';
  static const String _themeKey = 'is_dark_theme';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Water tracking
  static Future<void> saveWaterIntake(int amount) async {
    await _prefs.setInt(_waterIntakeKey, amount);
  }

  static int getWaterIntake() {
    return _prefs.getInt(_waterIntakeKey) ?? 0;
  }

  static Future<void> saveLastWaterReset(DateTime date) async {
    await _prefs.setString(_lastWaterResetKey, date.toIso8601String());
  }

  static DateTime? getLastWaterReset() {
    final dateStr = _prefs.getString(_lastWaterResetKey);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Achievements
  static Future<void> saveAchievements(
      List<String> unlockedAchievements) async {
    await _prefs.setStringList(_achievementsKey, unlockedAchievements);
  }

  static List<String> getUnlockedAchievements() {
    return _prefs.getStringList(_achievementsKey) ?? [];
  }

  // Theme
  static Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
  }

  static bool isDarkMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }
}
