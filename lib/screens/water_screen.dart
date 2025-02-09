import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/water_service.dart';
import '../widgets/wave_clipper.dart';
import '../widgets/base_screen.dart';
import '../widgets/water_timer.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fillAnimation = CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeInOut,
    );

    _fillController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  void _showIntervalPicker(
      BuildContext context, SettingsService settingsService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Установить интервал напоминаний'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите или введите интервал в минутах'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 45, 60].map((minutes) {
                return ActionChip(
                  label: Text('$minutes мин'),
                  onPressed: () {
                    settingsService.setWaterReminderInterval(minutes);
                    NotificationService().scheduleWaterReminder(
                      intervalMinutes: minutes,
                    );
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Свой интервал (минуты)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final minutes = int.tryParse(value);
                if (minutes != null && minutes > 0) {
                  settingsService.setWaterReminderInterval(minutes);
                  NotificationService().scheduleWaterReminder(
                    intervalMinutes: minutes,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Водный баланс',
      body: Consumer2<WaterService, SettingsService>(
        builder: (context, waterService, settingsService, _) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _buildWaterContainer(waterService),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(children: [
                        Center(
                          child: WaterTimer(
                            intervalMinutes:
                                settingsService.waterReminderInterval,
                            onTimerComplete: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Пора выпить воды!'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.timer),
                          label: const Text('Изменить интервал'),
                          onPressed: () => _showIntervalPicker(
                            context,
                            settingsService,
                          ),
                        ),
                      ]),
                    ),
                    _buildQuickAddButtons(waterService),
                  ],
                ),
              ),
              _buildBottomControls(waterService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWaterContainer(WaterService waterService) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(
                    _waveController.value,
                    waveHeight: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${waterService.dailyWaterAmount.toInt()}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'мл',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'из ${waterService.customDailyGoal.toInt()} мл',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddButtons(WaterService waterService) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWaterButton(100, waterService),
          _buildWaterButton(200, waterService),
          _buildWaterButton(300, waterService),
        ],
      ),
    );
  }

  Widget _buildWaterButton(int amount, WaterService waterService) {
    return ScaleTransition(
      scale: _fillAnimation,
      child: ElevatedButton(
        onPressed: () => waterService.addWater(amount),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Text(
          '$amount\nмл',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(WaterService waterService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Добавить другое количество',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCustomAmountDialog(context, waterService),
            icon: const Icon(Icons.add),
            label: const Text('Указать вручную'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomAmountDialog(
    BuildContext context,
    WaterService waterService,
  ) async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить воду'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Количество (мл)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                waterService.addWater(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
