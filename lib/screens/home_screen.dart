import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../services/meal_counter_service.dart';
import '../widgets/base_screen.dart';
import '../widgets/meal_progress_circle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Главная',
      showHomeButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          tooltip: 'Настройки',
        ),
      ],
      body: Column(
        children: [
          const SizedBox(height: 32),
          Consumer<MealCounterService>(
            builder: (context, mealService, _) => MealProgressCircle(
              progress: mealService.progressPercentage,
              remainingMeals: mealService.remainingMeals,
              onTap: () => mealService.addMeal(),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              alignment: WrapAlignment.center,
              children: [
                _buildNavigationButton(
                  context,
                  'Холодильник',
                  Icons.kitchen,
                  AppRoutes.fridge,
                ),
                _buildNavigationButton(
                  context,
                  'Вода',
                  Icons.water_drop,
                  AppRoutes.water,
                ),
                _buildNavigationButton(
                  context,
                  'Статистика',
                  Icons.bar_chart,
                  AppRoutes.stats,
                ),
                _buildNavigationButton(
                  context,
                  'Рецепты',
                  Icons.book,
                  AppRoutes.recipes,
                ),
                _buildNavigationButton(
                  context,
                  'Достижения',
                  Icons.emoji_events,
                  AppRoutes.achievements,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
