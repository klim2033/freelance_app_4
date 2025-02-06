import 'package:flutter/material.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final double _dailyGoal = 2000; // ml
  double _currentAmount = 0;
  
  void _addWater(double amount) {
    setState(() {
      _currentAmount = (_currentAmount + amount).clamp(0, _dailyGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Водный баланс'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${_currentAmount.toInt()} / ${_dailyGoal.toInt()} мл',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _currentAmount / _dailyGoal,
              minHeight: 20,
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _WaterButton(amount: 50, onTap: _addWater),
                _WaterButton(amount: 100, onTap: _addWater),
                _WaterButton(amount: 200, onTap: _addWater),
                _WaterButton(amount: 250, onTap: _addWater),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final double amount;
  final Function(double) onTap;

  const _WaterButton({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(amount),
      child: Text('+ ${amount.toInt()} мл'),
    );
  }
}
