
class Recipe {
  final String id;
  final String name;
  final String description;
  final List<RecipeIngredient> ingredients;
  final String instructions;
  final int cookingTimeMinutes;
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.cookingTimeMinutes,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'cookingTimeMinutes': cookingTimeMinutes,
      'imageUrl': imageUrl,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: (json['ingredients'] as List)
          .map((i) => RecipeIngredient.fromJson(i))
          .toList(),
      instructions: json['instructions'],
      cookingTimeMinutes: json['cookingTimeMinutes'],
      imageUrl: json['imageUrl'],
    );
  }
}

class RecipeIngredient {
  final String name;
  final double amount;
  final String unit;

  RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'],
      amount: json['amount'].toDouble(),
      unit: json['unit'],
    );
  }
}
