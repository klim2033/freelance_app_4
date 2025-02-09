import 'package:flutter/foundation.dart';
import '../models/meal_entry.dart';
import 'database_service.dart';

class FoodDiaryService extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<MealEntry> _entries = [];

  List<MealEntry> get entries => List.unmodifiable(_entries);

  Future<void> addEntry(MealEntry entry) async {
    await _db.insert('meal_entries', entry.toMap());
    _entries.add(entry);
    notifyListeners();
  }

  Future<void> loadEntries() async {
    final maps = await _db.getAll('meal_entries');
    _entries = maps.map((map) => MealEntry.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _db.delete('meal_entries', id);
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }

  List<MealEntry> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.dateTime.year == date.year &&
          entry.dateTime.month == date.month &&
          entry.dateTime.day == date.day;
    }).toList();
  }

  int getTotalCaloriesForDate(DateTime date) {
    return getEntriesForDate(date)
        .fold(0, (sum, entry) => sum + entry.calories);
  }

  Map<String, double> getNutrientsForDate(DateTime date) {
    var entries = getEntriesForDate(date);
    return {
      'proteins': entries.fold(0.0, (sum, entry) => sum + entry.proteins),
      'fats': entries.fold(0.0, (sum, entry) => sum + entry.fats),
      'carbs': entries.fold(0.0, (sum, entry) => sum + entry.carbs),
    };
  }
}
