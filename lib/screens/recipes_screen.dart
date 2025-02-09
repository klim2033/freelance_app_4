import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/recipe.dart';
import '../services/product_service.dart';
import '../services/recipe_service.dart';
import '../widgets/add_recipe_dialog.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  void _showAddRecipeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRecipeDialog(
        onAdd: (recipe) {
          context.read<RecipeService>().addRecipe(recipe);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe) {
    final recipeService = context.read<RecipeService>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    recipe.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                recipe.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text('${recipe.cookingTimeMinutes} мин'),
                    avatar: const Icon(Icons.timer, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Описание',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(recipe.description),
              const SizedBox(height: 16),
              Text(
                'Ингредиенты',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...recipe.ingredients.map((ingredient) {
                final isAvailable = recipeService.isIngredientAvailable(
                  ingredient.name,
                  ingredient.amount,
                  ingredient.unit,
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.error,
                        size: 16,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ingredient.name} - ${ingredient.amount}${ingredient.unit}',
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Text(
                'Шаги приготовления',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(recipe.instructions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRecipeDialog(context),
          ),
        ],
      ),
      body: Consumer2<RecipeService, ProductService>(
          builder: (context, recipeService, productService, child) {
        return StreamBuilder<List<Product>>(
          stream: productService.productsStream,
          builder: (context, snapshot) {
            final recipes = recipeService.sortedRecipes;

            if (recipes.isEmpty) {
              return const Center(
                child: Text('Нет доступных рецептов'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final isAvailable =
                    recipeService.isRecipeFullyAvailable(recipe);

                return Card(
                  color: isAvailable
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  child: ListTile(
                    leading: recipe.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              recipe.imageUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.restaurant),
                    title: Text(
                      recipe.name,
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${_getAvailabilityText(recipeService, recipe)}\n'
                      '${recipe.cookingTimeMinutes} мин',
                      style: TextStyle(
                        color: isAvailable
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                    onTap: () => _showRecipeDetails(context, recipe),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}

String _getAvailabilityText(RecipeService service, Recipe recipe) {
  final percentage = service.calculateAvailabilityPercentage(recipe) * 100;
  final missingIngredients = service.getMissingIngredients(recipe);

  if (missingIngredients.isEmpty) {
    return 'Все ингредиенты в наличии';
  }

  return 'Доступно: ${percentage.toInt()}%\nОтсутствует: ${missingIngredients.join(", ")}';
}
