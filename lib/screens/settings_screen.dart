import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/settings_service.dart';
import '../services/theme_service.dart';
import '../widgets/base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Настройки',
      body: ListView(
        children: [
          _buildSection(
            'Внешний вид',
            [
              Consumer<ThemeService>(
                builder: (context, themeService, _) => SwitchListTile(
                  title: const Text('Темная тема'),
                  value: themeService.isDarkMode,
                  onChanged: (bool value) {
                    themeService.toggleTheme();
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            'Напоминания',
            [
              Consumer<SettingsService>(
                builder: (context, settingsService, _) => ListTile(
                  title: const Text('Интервал напоминаний о воде'),
                  subtitle:
                      Text('${settingsService.waterReminderInterval} минут'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showIntervalPicker(context, settingsService),
                ),
              ),
            ],
          ),
          _buildSection(
            'О приложении',
            [
              ListTile(
                title: const Text('Версия'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Лицензии'),
                onTap: () => showLicensePage(context: context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _showIntervalPicker(
      BuildContext context, SettingsService settingsService) async {
    final intervals = [15, 30, 45, 60, 90, 120];
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите интервал'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: intervals
              .map(
                (interval) => ListTile(
                  title: Text('$interval минут'),
                  onTap: () {
                    settingsService.setWaterReminderInterval(interval);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
