import 'package:flutter/material.dart';
import 'package:freelance_app_4/models/user_data.dart';
// import 'package:freelance_app_4/database/database_helper.dart'; // Commented out database import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;
  bool _isLoading = true;
  bool _hasError = false;
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  Gender _gender = Gender.male;
  ActivityLevel _activityLevel = ActivityLevel.medium;
  Goal _goal = Goal.maintain;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() => _isLoading = true);
      // await DatabaseHelper.instance.checkDatabaseConnection(); // Commented out database connection check
      await _loadUserData();
    } catch (e) {
      debugPrint('Initialization error: $e');
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserData() async {
    // Temporary mock data instead of database
    if (mounted) {
      setState(() {
        userData = UserData(
          weight: 70,
          height: 170,
          age: 25,
          gender: Gender.male,
          activityLevel: ActivityLevel.medium,
          goal: Goal.maintain,
        );
        if (userData != null) {
          _weightController.text = userData!.weight.toString();
          _heightController.text = userData!.height.toString();
          _ageController.text = userData!.age.toString();
          _gender = userData!.gender;
          _activityLevel = userData!.activityLevel;
          _goal = userData!.goal;
        }
      });
    }
  }

  void _showUserDataForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ваши данные'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Вес (кг)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите вес';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Рост (см)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите рост';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Возраст'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите возраст';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Gender>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Пол'),
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender == Gender.male ? 'Мужской' : 'Женский'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                DropdownButtonFormField<ActivityLevel>(
                  value: _activityLevel,
                  decoration: const InputDecoration(labelText: 'Уровень активности'),
                  items: ActivityLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text({
                        ActivityLevel.low: 'Низкий',
                        ActivityLevel.medium: 'Средний',
                        ActivityLevel.high: 'Высокий',
                      }[level]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _activityLevel = value!;
                    });
                  },
                ),
                DropdownButtonFormField<Goal>(
                  value: _goal,
                  decoration: const InputDecoration(labelText: 'Цель'),
                  items: Goal.values.map((goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Text({
                        Goal.loss: 'Похудение',
                        Goal.maintain: 'Поддержание',
                        Goal.gain: 'Набор массы',
                      }[goal]!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _goal = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: _saveUserData,
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final newUserData = UserData(
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        gender: _gender,
        activityLevel: _activityLevel,
        goal: _goal,
      );
      
      // await DatabaseHelper.instance.saveUserData(newUserData); // Commented out database save
      
      if (mounted) {
        setState(() {
          userData = newUserData;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showUserDataForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Произошла ошибка при загрузке данных'),
                      ElevatedButton(
                        onPressed: _initializeData,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : userData == null
                  ? Center(
                      child: ElevatedButton(
                        onPressed: _showUserDataForm,
                        child: const Text('Ввести данные'),
                      ),
                    )
                  : _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Дневная норма: ${userData!.calculateDailyCalories().toStringAsFixed(0)} ккал',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          const Text('Рекомендуемое потребление БЖУ:'),
          // TODO: Add progress indicators for proteins, fats, carbs
        ],
      ),
    );
  }
}
