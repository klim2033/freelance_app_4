import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_entry.dart';
import '../models/product.dart';
import 'database_service.dart';

class BackupService {
  final DatabaseService _db = DatabaseService.instance;

  Future<Map<String, dynamic>> createBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final backupData = {
      'timestamp': DateTime.now().toIso8601String(),
      'preferences': prefs
          .getKeys()
          .map((key) => {
                'key': key,
                'value': prefs.get(key),
              })
          .toList(),
      'meals': await _db.query('meal_entries'),
      'products': await _db.getAllProducts(),
      // Add other data you want to backup
    };

    return backupData;
  }

  Future<String> exportBackup() async {
    try {
      final backupData = await createBackup();
      final jsonData = json.encode(backupData);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/food_control_backup.json');
      await file.writeAsString(jsonData);

      return file.path;
    } catch (e) {
      throw Exception('Не удалось создать резервную копию: $e');
    }
  }

  Future<void> restoreBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Файл резервной копии не найден');
      }

      final jsonData = await file.readAsString();
      final backupData = json.decode(jsonData);

      // Restore SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      for (var prefData in backupData['preferences']) {
        final key = prefData['key'];
        final value = prefData['value'];
        if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is String) {
          await prefs.setString(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        }
      }

      // Restore database
      final db = await _db.database;

      // Clear all tables
      await db.delete('meal_entries');
      await db.delete('products');

      // Restore meals
      for (var mealData in backupData['meals']) {
        await db.insert('meal_entries', MealEntry.fromMap(mealData).toMap());
      }

      // Restore products
      for (var productData in backupData['products']) {
        await db.insert('products', Product.fromMap(productData).toMap());
      }
    } catch (e) {
      throw Exception('Не удалось восстановить резервную копию: $e');
    }
  }

  Future<bool> backupExists() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/food_control_backup.json');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> getLastBackupDate() async {
    try {
      if (await backupExists()) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/food_control_backup.json');
        final jsonData = await file.readAsString();
        final backupData = json.decode(jsonData);
        return DateTime.parse(backupData['timestamp']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
