import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/fridge_screen.dart';
import '../screens/recipes_screen.dart';
import '../screens/water_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String fridge = '/fridge';
  static const String recipes = '/recipes';
  static const String water = '/water';
  static const String stats = '/stats';
  static const String achievements = '/achievements';
  static const String settings = '/settings';

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const HomeScreen(),
    fridge: (context) => const FridgeScreen(),
    recipes: (context) => const RecipesScreen(),
    water: (context) => const WaterScreen(),
    stats: (context) => const StatsScreen(),
    achievements: (context) => const AchievementsScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
