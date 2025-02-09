import 'package:flutter/material.dart';
import '../models/meal_entry.dart';

class MealCard extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback onDelete;

  const MealCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  String _getMealTypeIcon() {
    switch (entry.mealType) {
      case 'breakfast':
        return '🍳';
      case 'lunch':
        return '🍲';
      case 'dinner':
        return '🍽️';
      case 'snack':
        return '🥨';
      default:
        return '🍴';
    }
  }

  String _getMealTypeName() {
    switch (entry.mealType) {
      case 'breakfast':
        return 'Завтрак';
      case 'lunch':
        return 'Обед';
      case 'dinner':
        return 'Ужин';
      case 'snack':
        return 'Перекус';
      default:
        return entry.mealType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: Key(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) => onDelete(),
        child: ListTile(
          leading: Text(
            _getMealTypeIcon(),
            style: const TextStyle(fontSize: 24),
          ),
          title: Text(entry.foodName),
          subtitle: Text(
            'Б: ${entry.proteins}г • Ж: ${entry.fats}г • У: ${entry.carbs}г',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.calories} ккал',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                _getMealTypeName(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
