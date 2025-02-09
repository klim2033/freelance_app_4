import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

class RecipeService extends ChangeNotifier {
  static const String _recipesKey = 'recipes';
  static const String _availableIngredientsKey = 'available_ingredients';

  final SharedPreferences _prefs;
  List<Recipe> _recipes = [];
  List<Map<String, dynamic>> _availableIngredients = [];

  RecipeService(this._prefs) {
    _loadData();
  }

  List<Recipe> get recipes => _recipes;
  List<Map<String, dynamic>> get availableIngredients => _availableIngredients;

  List<Recipe> get sortedRecipes {
    return List<Recipe>.from(_recipes)
      ..sort((a, b) {
        // First compare full availability
        bool isAFullyAvailable = isRecipeFullyAvailable(a);
        bool isBFullyAvailable = isRecipeFullyAvailable(b);

        if (isAFullyAvailable != isBFullyAvailable) {
          return isAFullyAvailable ? -1 : 1;
        }

        // If both have same availability status, compare by percentage
        double availabilityA = calculateAvailabilityPercentage(a);
        double availabilityB = calculateAvailabilityPercentage(b);

        // If percentages are equal, sort by name
        if (availabilityA == availabilityB) {
          return a.name.compareTo(b.name);
        }

        return availabilityB.compareTo(availabilityA);
      });
  }

  List<String> getMissingIngredients(Recipe recipe) {
    return recipe.ingredients
        .where((ingredient) => !isIngredientAvailable(
              ingredient.name,
              ingredient.amount,
              ingredient.unit,
            ))
        .map((ingredient) => ingredient.name)
        .toList();
  }

  bool isIngredientAvailable(
      String ingredientName, double amount, String unit) {
    try {
      final normalizedName = ingredientName.trim().toLowerCase();

      // Find ingredients with matching name only
      final matchingIngredients = _availableIngredients
          .where((ingredient) =>
              ingredient['name'].toString().toLowerCase() == normalizedName)
          .toList();

      if (matchingIngredients.isEmpty) return false;

      // Sum up all quantities of matching ingredients
      double totalQuantity = 0.0;
      for (final ingredient in matchingIngredients) {
        final quantity = ingredient['quantity'];
        if (quantity != null) {
          totalQuantity +=
              quantity is int ? quantity.toDouble() : quantity as double;
        }
      }

      return totalQuantity >= amount;
    } catch (e) {
      debugPrint('Ошибка при проверке доступности ингредиента: $e');
      return false;
    }
  }

  double calculateAvailabilityPercentage(Recipe recipe) {
    if (recipe.ingredients.isEmpty) {
      return 0.0;
    }

    int availableCount = recipe.ingredients.where((ingredient) {
      return isIngredientAvailable(
        ingredient.name,
        ingredient.amount,
        ingredient.unit,
      );
    }).length;

    return availableCount / recipe.ingredients.length;
  }

  bool isRecipeFullyAvailable(Recipe recipe) {
    return calculateAvailabilityPercentage(recipe) == 1.0;
  }

  Future<void> addRecipe(Recipe recipe) async {
    _recipes.add(recipe);
    await _saveRecipes();
    notifyListeners();
  }

  Future<void> updateAvailableIngredients(
      List<Map<String, dynamic>> ingredients) async {
    try {
      _availableIngredients = ingredients.map((ingredient) {
        // Normalize the ingredient data
        var normalized = Map<String, dynamic>.from(ingredient);
        normalized['name'] =
            (ingredient['name'] as String).trim().toLowerCase();
        normalized['quantity'] = ingredient['quantity'] is int
            ? (ingredient['quantity'] as int).toDouble()
            : (ingredient['quantity'] as num).toDouble();
        return normalized;
      }).toList();

      await _saveAvailableIngredients();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при обновлении ингредиентов: $e');
      rethrow;
    }
  }

  Future<void> addAvailableIngredient(Map<String, dynamic> ingredient) async {
    try {
      var normalizedIngredient = {
        'name': (ingredient['name'] as String).trim().toLowerCase(),
        'quantity': ingredient['quantity'] is int
            ? (ingredient['quantity'] as int).toDouble()
            : (ingredient['quantity'] as num).toDouble(),
        'unit': ingredient['unit'],
      };

      // Check for existing ingredient with same name and unit
      final existingIndex = _availableIngredients.indexWhere((item) =>
          item['name'] == normalizedIngredient['name'] &&
          item['unit'] == normalizedIngredient['unit']);

      if (existingIndex != -1) {
        // Update existing ingredient quantity
        _availableIngredients[existingIndex]['quantity'] =
            (normalizedIngredient['quantity'] as double) +
                (_availableIngredients[existingIndex]['quantity'] as double);
      } else {
        _availableIngredients.add(normalizedIngredient);
      }

      await _saveAvailableIngredients();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при добавлении ингредиента: $e');
      rethrow;
    }
  }

  Future<void> removeAvailableIngredient(
      Map<String, dynamic> ingredient) async {
    try {
      final normalizedName =
          (ingredient['name'] as String).trim().toLowerCase();

      _availableIngredients.removeWhere((item) =>
          item['name'] == normalizedName && item['unit'] == ingredient['unit']);

      await _saveAvailableIngredients();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при удалении ингредиента: $e');
      rethrow;
    }
  }

  void _loadData() {
    try {
      final recipesJson = _prefs.getString(_recipesKey);
      if (recipesJson != null) {
        final List<dynamic> decoded = json.decode(recipesJson);
        _recipes = decoded.map((item) => Recipe.fromJson(item)).toList();
      }

      final ingredientsJson = _prefs.getString(_availableIngredientsKey);
      if (ingredientsJson != null) {
        final List<dynamic> decoded = json.decode(ingredientsJson);
        _availableIngredients = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          if (map['quantity'] is int) {
            map['quantity'] = map['quantity'].toDouble();
          }
          return map;
        }).toList();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при загрузке данных: $e');
      _recipes = [];
      _availableIngredients = [];
    }
  }

  Future<void> _saveRecipes() async {
    try {
      final String encoded =
          json.encode(_recipes.map((e) => e.toJson()).toList());
      await _prefs.setString(_recipesKey, encoded);
    } catch (e) {
      debugPrint('Ошибка при сохранении рецептов: $e');
    }
  }

  Future<void> _saveAvailableIngredients() async {
    try {
      final String encoded = json.encode(_availableIngredients);
      await _prefs.setString(_availableIngredientsKey, encoded);
    } catch (e) {
      debugPrint('Ошибка при сохранении ингредиентов: $e');
    }
  }
}
