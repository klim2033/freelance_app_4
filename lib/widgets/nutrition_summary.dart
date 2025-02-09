import 'package:flutter/material.dart';

class NutritionSummary extends StatelessWidget {
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  const NutritionSummary({
    super.key,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
              '$calories ккал',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutrientInfo(context, 'Белки', proteins, Colors.blue),
                _buildNutrientInfo(context, 'Жиры', fats, Colors.orange),
                _buildNutrientInfo(context, 'Углеводы', carbs, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(1)}г',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
