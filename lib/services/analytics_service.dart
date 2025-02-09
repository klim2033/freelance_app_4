import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static const String _lastOpenKey = 'last_open_date';
  static const String _openCountKey = 'open_count';
  static const String _screenTimeKey = 'screen_time';
  static const String _featureUsageKey = 'feature_usage';

  final SharedPreferences _prefs;

  AnalyticsService(this._prefs);

  Future<void> trackAppOpen() async {
    final currentDate = DateTime.now().toIso8601String();
    await _prefs.setString(_lastOpenKey, currentDate);

    final openCount = _prefs.getInt(_openCountKey) ?? 0;
    await _prefs.setInt(_openCountKey, openCount + 1);
  }

  Future<void> trackScreenTime(String screenName, int seconds) async {
    final screenTime = _prefs.getStringList(_screenTimeKey) ?? [];
    screenTime.add('$screenName:$seconds:${DateTime.now().toIso8601String()}');
    await _prefs.setStringList(_screenTimeKey, screenTime);
  }

  Future<void> trackFeatureUsage(String featureName) async {
    final featureUsage = _prefs.getStringList(_featureUsageKey) ?? [];
    featureUsage.add('$featureName:${DateTime.now().toIso8601String()}');
    await _prefs.setStringList(_featureUsageKey, featureUsage);
  }

  Map<String, dynamic> getAnalytics() {
    return {
      'lastOpen': _prefs.getString(_lastOpenKey),
      'openCount': _prefs.getInt(_openCountKey) ?? 0,
      'screenTime': _prefs.getStringList(_screenTimeKey) ?? [],
      'featureUsage': _prefs.getStringList(_featureUsageKey) ?? [],
    };
  }

  Future<void> clearAnalytics() async {
    await _prefs.remove(_lastOpenKey);
    await _prefs.remove(_openCountKey);
    await _prefs.remove(_screenTimeKey);
    await _prefs.remove(_featureUsageKey);
  }
}
