import 'package:freelance_app_4/product.dart';

class Recipe {
  final String id;
  final String name;
  final List<RecipeIngredient> ingredients;
  final String instructions;
  
  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'instructions': instructions,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: [], // Need to load ingredients separately
      instructions: map['instructions'],
    );
  }
}

class RecipeIngredient {
  final Product product;
  final double quantity;

  RecipeIngredient({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': product.id,
      'quantity': quantity,
    };
  }
}
