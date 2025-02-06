// Rename this file to database_helper.dart.bak or move it to a backup folder
/*
import 'package:freelance_app_4/models/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:freelance_app_4/product.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    try {
      if (_database != null) return _database!;
      _database = await _initDB('food_control.db');
      return _database!;
    } catch (e) {
      debugPrint('Database initialization error: $e');
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) async {
          debugPrint('Database opened successfully');
        },
      );
    } catch (e) {
      debugPrint('Database creation error: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Таблица продуктов
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        calories REAL NOT NULL,
        proteins REAL NOT NULL,
        fats REAL NOT NULL,
        carbs REAL NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL
      )
    ''');

    // Таблица пользовательских данных
    await db.execute('''
      CREATE TABLE user_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        height REAL NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        activity_level TEXT NOT NULL,
        goal TEXT NOT NULL,
        water_goal REAL NOT NULL
      )
    ''');

    // Таблица рецептов
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        instructions TEXT NOT NULL
      )
    ''');

    // Таблица компонентов рецептов
    await db.execute('''
      CREATE TABLE recipe_ingredients (
        recipe_id TEXT,
        product_id TEXT,
        quantity REAL NOT NULL,
        FOREIGN KEY (recipe_id) REFERENCES recipes (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // Таблица потребления воды
    await db.execute('''
      CREATE TABLE water_intake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // CRUD операции для продуктов
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Операции с водой
  Future<void> addWaterIntake(double amount) async {
    final db = await instance.database;
    await db.insert('water_intake', {
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<double> getTodayWaterIntake() async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().split('T')[0];
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM water_intake
      WHERE timestamp LIKE '$today%'
    ''');
    return result.first['total'] as double? ?? 0.0;
  }

  // User Data operations
  Future<void> saveUserData(UserData userData) async {
    final db = await instance.database;
    await db.insert(
      'user_data',
      userData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserData?> getUserData() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('user_data');
    if (maps.isEmpty) return null;
    return UserData.fromMap(maps.first);
  }

  // Additional utility methods
  Future<void> clearAllTables() async {
    final db = await instance.database;
    await db.delete('products');
    await db.delete('user_data');
    await db.delete('water_intake');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  // Добавьте метод для проверки соединения
  Future<bool> checkDatabaseConnection() async {
    try {
      final db = await database;
      await db.rawQuery('SELECT 1');
      return true;
    } catch (e) {
      debugPrint('Database connection check failed: $e');
      return false;
    }
  }
}
*/
