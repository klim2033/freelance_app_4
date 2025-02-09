class DailyStats {
  final int steps;
  final int calories;
  final int distance;
  final int targetSteps;
  final DateTime date;

  DailyStats({
    this.steps = 0,
    this.calories = 0,
    this.distance = 0,
    this.targetSteps = 10000,
    required this.date,
  });

  double get progressPercentage => steps / targetSteps;

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      steps: map['steps'] ?? 0,
      calories: map['calories'] ?? 0,
      distance: map['distance'] ?? 0,
      targetSteps: map['targetSteps'] ?? 10000,
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'calories': calories,
      'distance': distance,
      'targetSteps': targetSteps,
      'date': date.toIso8601String(),
    };
  }

  DailyStats copyWith({
    int? steps,
    int? calories,
    int? distance,
    int? targetSteps,
    DateTime? date,
  }) {
    return DailyStats(
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      targetSteps: targetSteps ?? this.targetSteps,
      date: date ?? this.date,
    );
  }
}
