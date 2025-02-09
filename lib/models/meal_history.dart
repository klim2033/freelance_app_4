
enum MealType { breakfast, lunch, dinner, snack }

class MealEntry {
  final String id;
  final DateTime date;
  final MealType type;
  final String description;
  final int calories;

  MealEntry({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.calories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'description': description,
      'calories': calories,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: MealType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      description: json['description'],
      calories: json['calories'],
    );
  }
}
