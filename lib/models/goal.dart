enum GoalType { calories, water, protein, weight, custom }

enum GoalPeriod { daily, weekly, monthly }

class Goal {
  final String id;
  final String title;
  final GoalType type;
  final GoalPeriod period;
  final double target;
  final double current;
  final String unit;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCompleted;

  Goal({
    required this.id,
    required this.title,
    required this.type,
    required this.period,
    required this.target,
    this.current = 0,
    required this.unit,
    required this.startDate,
    this.endDate,
    this.isCompleted = false,
  });

  Goal copyWith({
    String? id,
    String? title,
    GoalType? type,
    GoalPeriod? period,
    double? target,
    double? current,
    String? unit,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      period: period ?? this.period,
      target: target ?? this.target,
      current: current ?? this.current,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progress => current / target;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toString(),
      'period': period.toString(),
      'target': target,
      'current': current,
      'unit': unit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      type: GoalType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      period: GoalPeriod.values.firstWhere(
        (e) => e.toString() == map['period'],
      ),
      target: map['target'],
      current: map['current'],
      unit: map['unit'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
