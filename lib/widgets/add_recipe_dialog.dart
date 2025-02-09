import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AddRecipeDialog extends StatefulWidget {
  final Function(Recipe) onAdd;

  const AddRecipeDialog({super.key, required this.onAdd});

  @override
  State<AddRecipeDialog> createState() => _AddRecipeDialogState();
}

class _AddRecipeDialogState extends State<AddRecipeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  String _selectedCategory = 'Завтрак';
  String _selectedDifficulty = 'Легко';

  final List<String> _categories = [
    'Завтрак',
    'Обед',
    'Ужин',
    'Десерты',
    'Салаты',
    'Супы'
  ];
  final List<String> _difficulties = ['Легко', 'Средне', 'Сложно'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        id: DateTime.now().toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text
            .split('\n')
            .map((ingredient) =>
                RecipeIngredient(name: ingredient, amount: 0, unit: ''))
            .toList(),
        instructions: _stepsController.text,
        cookingTimeMinutes: int.parse(_cookingTimeController.text),
      );
      widget.onAdd(recipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Название рецепта'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 2,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите описание' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Категория'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cookingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Время приготовления (минуты)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите время' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Сложность'),
                items: _difficulties.map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ингредиенты (каждый с новой строки)',
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Введите ингредиенты' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Шаги приготовления (каждый с новой строки)',
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Введите шаги приготовления'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Добавить рецепт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
