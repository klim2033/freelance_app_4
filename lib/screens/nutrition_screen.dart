import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/food_diary_service.dart';
import '../models/meal_entry.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
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
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddMealForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Питание'),
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
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Итого за день',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalCalories ккал',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutrientInfo('Белки', nutrients['proteins']!),
                          _buildNutrientInfo('Жиры', nutrients['fats']!),
                          _buildNutrientInfo('Углеводы', nutrients['carbs']!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Dismissible(
                      key: Key(entry.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        foodDiary.deleteEntry(entry.id);
                      },
                      child: ListTile(
                        title: Text(entry.foodName),
                        subtitle: Text(
                          '${entry.calories} ккал • Б: ${entry.proteins}г Ж: ${entry.fats}г У: ${entry.carbs}г',
                        ),
                        trailing: Text(
                          entry.mealType,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
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

  Widget _buildNutrientInfo(String label, double value) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(1)}г',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class AddMealForm extends StatefulWidget {
  const AddMealForm({super.key});

  @override
  State<AddMealForm> createState() => _AddMealFormState();
}

class _AddMealFormState extends State<AddMealForm> {
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
                  context.read<FoodDiaryService>().addEntry(entry);
                  Navigator.pop(context);
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
