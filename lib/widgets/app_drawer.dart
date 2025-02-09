import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35),
                ),
                const SizedBox(height: 10),
                Text(
                  'Контроль питания',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.kitchen),
            title: const Text('Холодильник'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.fridge);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Рецепты'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.recipes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Вода'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.water);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Статистика'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.stats);
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Достижения'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.achievements);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
