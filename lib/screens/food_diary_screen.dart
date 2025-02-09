import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/food_diary_service.dart';
import '../models/meal_entry.dart';
import 'package:intl/intl.dart';

class FoodDiaryScreen extends StatefulWidget {
  const FoodDiaryScreen({super.key});

  @override
  State<FoodDiaryScreen> createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodDiaryService>().loadEntries();
    });
  }

  void _showAddEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddMealEntryForm(),
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
          final totalCalories =
              foodDiary.getTotalCaloriesForDate(_selectedDate);
          final nutrients = foodDiary.getNutrientsForDate(_selectedDate);

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('d MMMM yyyy').format(_selectedDate),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Всего калорий: $totalCalories',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Б: ${nutrients['proteins']?.toStringAsFixed(1)}г • Ж: ${nutrients['fats']?.toStringAsFixed(1)}г • У: ${nutrients['carbs']?.toStringAsFixed(1)}г',
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
                    return ListTile(
                      title: Text(entry.foodName),
                      subtitle: Text(
                        '${entry.mealType} • ${entry.calories} ккал',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => foodDiary.deleteEntry(entry.id),
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
        onPressed: _showAddEntryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMealEntryForm extends StatefulWidget {
  const AddMealEntryForm({super.key});

  @override
  State<AddMealEntryForm> createState() => _AddMealEntryFormState();
}

class _AddMealEntryFormState extends State<AddMealEntryForm> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = '';
  String _mealType = 'breakfast';
  int _calories = 0;
  double _proteins = 0;
  double _fats = 0;
  double _carbs = 0;
  String? _notes;

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
            TextFormField(
              decoration: const InputDecoration(labelText: 'Заметки'),
              maxLines: 2,
              onSaved: (value) => _notes = value,
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
                    notes: _notes,
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
