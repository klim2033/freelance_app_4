import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../models/meal_entry.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food_control.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Products table
    await db.execute('''
		CREATE TABLE products (
			id $idType,
			name $textType,
			category $textType,
			expirationDate $textType,
			quantity $integerType,
			unit $textType
		)
		''');

    // Recipes table
    await db.execute('''
		CREATE TABLE recipes (
			id $idType,
			name $textType,
			description $textType,
			imageUrl $textType,
			cookingTime $integerType,
			difficulty $textType
		)
		''');

    // Recipe ingredients table
    await db.execute('''
		CREATE TABLE recipe_ingredients (
			id $idType,
			recipeId INTEGER NOT NULL,
			name $textType,
			quantity $integerType,
			unit $textType,
			FOREIGN KEY (recipeId) REFERENCES recipes (id) ON DELETE CASCADE
		)
		''');

    // Recipe steps table
    await db.execute('''
		CREATE TABLE recipe_steps (
			id $idType,
			recipeId INTEGER NOT NULL,
			stepNumber $integerType,
			description $textType,
			FOREIGN KEY (recipeId) REFERENCES recipes (id) ON DELETE CASCADE
)
''');

    Future<int> createProduct(Product product) async {
      final db = await database;
      return await db.insert('products', {
        'name': product.name,
        'category': product.category,
        'expirationDate': product.expirationDate.toIso8601String(),
        'quantity': product.quantity,
        'unit': product.unit,
      });
    }

    Future<List<Product>> getAllProducts() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('products');

      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'].toString(),
          name: maps[i]['name'],
          category: maps[i]['category'],
          expirationDate: DateTime.parse(maps[i]['expirationDate']),
          quantity: maps[i]['quantity'],
          unit: maps[i]['unit'],
        );
      });
    }

    Future<int> updateProduct(Product product) async {
      final db = await database;
      return await db.update(
        'products',
        {
          'name': product.name,
          'category': product.category,
          'expirationDate': product.expirationDate.toIso8601String(),
          'quantity': product.quantity,
          'unit': product.unit,
        },
        where: 'id = ?',
        whereArgs: [product.id],
      );
    }

    Future<int> deleteProduct(String id) async {
      final db = await database;
      return await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    // Meal entries CRUD operations
    Future<void> createMealEntry(MealEntry entry) async {
      final db = await database;
      await db.insert('meal_entries', entry.toMap());
    }

    Future<List<MealEntry>> getMealEntries() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('meal_entries');

      return List.generate(maps.length, (i) => MealEntry.fromMap(maps[i]));
    }

    Future<void> deleteMealEntry(String id) async {
      final db = await database;
      await db.delete(
        'meal_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    // Close database
    Future<void> close() async {
      final db = await database;
      db.close();
    }
  }

  getAllProducts() {}

  query(String s) {}

  delete(String s, String id) {}

  insert(String s, Map<String, dynamic> map) {}

  getAll(String s) {}
}
