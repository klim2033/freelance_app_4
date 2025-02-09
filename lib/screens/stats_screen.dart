import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/meal_history_service.dart';
import '../models/meal_history.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика питания'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildMealList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealList() {
    return Consumer<MealHistoryService>(
      builder: (context, mealHistory, child) {
        final meals = mealHistory.getMealsForDate(_selectedDay);

        if (meals.isEmpty) {
          return const Center(
            child: Text('Нет записей на этот день'),
          );
        }

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              child: ListTile(
                leading: _getMealIcon(meal.type),
                title: Text(_getMealTypeText(meal.type)),
                subtitle: Text(meal.description),
                trailing: Text('${meal.calories} ккал'),
              ),
            );
          },
        );
      },
    );
  }

  Icon _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return const Icon(Icons.breakfast_dining);
      case MealType.lunch:
        return const Icon(Icons.lunch_dining);
      case MealType.dinner:
        return const Icon(Icons.dinner_dining);
      case MealType.snack:
        return const Icon(Icons.restaurant);
    }
  }

  String _getMealTypeText(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Завтрак';
      case MealType.lunch:
        return 'Обед';
      case MealType.dinner:
        return 'Ужин';
      case MealType.snack:
        return 'Перекус';
    }
  }
}
