import 'package:flutter/material.dart';
import '../models/meal_entry.dart';
import 'package:provider/provider.dart';
import '../services/food_diary_service.dart';
import '../widgets/meal_card.dart';
import '../widgets/nutrition_summary.dart';

class AddMealDialog extends StatefulWidget {
  final Function(MealEntry) onSave;

  const AddMealDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = '';
  String _mealType = 'breakfast';
  int _calories = 0;
  double _proteins = 0;
  double _fats = 0;
  double _carbs = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Название блюда'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Введите название' : null,
              onSaved: (value) => _foodName = value ?? '',
            ),
            DropdownButtonFormField<String>(
              value: _mealType,
              items: const [
                DropdownMenuItem(
                  value: 'breakfast',
                  child: Text('Завтрак'),
                ),
                DropdownMenuItem(
                  value: 'lunch',
                  child: Text('Обед'),
                ),
                DropdownMenuItem(
                  value: 'dinner',
                  child: Text('Ужин'),
                ),
                DropdownMenuItem(
                  value: 'snack',
                  child: Text('Перекус'),
                ),
              ],
              onChanged: (value) => setState(() => _mealType = value!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Калории'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Введите калории' : null,
              onSaved: (value) => _calories = int.parse(value ?? '0'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Белки (г)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _proteins = double.parse(value ?? '0'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Жиры (г)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _fats = double.parse(value ?? '0'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Углеводы (г)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _carbs = double.parse(value ?? '0'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  final entry = MealEntry(
                    id: DateTime.now().toString(),
                    dateTime: DateTime.now(),
                    mealType: _mealType,
                    foodName: _foodName,
                    calories: _calories,
                    proteins: _proteins,
                    fats: _fats,
                    carbs: _carbs,
                  );
                  widget.onSave(entry);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionTrackingScreen extends StatefulWidget {
  const NutritionTrackingScreen({super.key});

  @override
  State<NutritionTrackingScreen> createState() =>
      _NutritionTrackingScreenState();
}

class _NutritionTrackingScreenState extends State<NutritionTrackingScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    await context.read<FoodDiaryService>().loadEntries();
  }

  void _showAddMealDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddMealDialog(
        onSave: (MealEntry entry) {
          context.read<FoodDiaryService>().addEntry(entry);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник питания'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
        ],
      ),
      body: Consumer<FoodDiaryService>(
        builder: (context, foodDiary, child) {
          final entries = foodDiary.getEntriesForDate(_selectedDate);
          final nutrients = foodDiary.getNutrientsForDate(_selectedDate);
          final totalCalories =
              foodDiary.getTotalCaloriesForDate(_selectedDate);

          return Column(
            children: [
              NutritionSummary(
                calories: totalCalories,
                proteins: nutrients['proteins'] ?? 0,
                fats: nutrients['fats'] ?? 0,
                carbs: nutrients['carbs'] ?? 0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return MealCard(
                      entry: entry,
                      onDelete: () {
                        foodDiary.deleteEntry(entry.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
