class MealEntry {
  final String id;
  final DateTime dateTime;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final String foodName;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;
  final String? notes;

  MealEntry({
    required this.id,
    required this.dateTime,
    required this.mealType,
    required this.foodName,
    required this.calories,
    this.proteins = 0,
    this.fats = 0,
    this.carbs = 0,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbs': carbs,
      'notes': notes,
    };
  }

  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      mealType: map['mealType'],
      foodName: map['foodName'],
      calories: map['calories'],
      proteins: map['proteins'],
      fats: map['fats'],
      carbs: map['carbs'],
      notes: map['notes'],
    );
  }
}
