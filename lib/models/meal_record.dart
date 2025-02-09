
enum MealType { breakfast, lunch, dinner, snack }

class MealRecord {
  final String id;
  final DateTime date;
  final MealType type;
  final String description;
  final int calories;
  final List<String> foods;

  MealRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.calories,
    required this.foods,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'description': description,
      'calories': calories,
      'foods': foods,
    };
  }

  factory MealRecord.fromJson(Map<String, dynamic> json) {
    return MealRecord(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: MealType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      description: json['description'],
      calories: json['calories'],
      foods: List<String>.from(json['foods']),
    );
  }

  String get typeInRussian {
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
