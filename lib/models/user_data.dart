import 'enums/gender.dart';
import 'enums/activity_level.dart';
import 'enums/goal_type.dart';

class UserData {
  final String? id;
  final int weight;
  final int height;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;
  final GoalType goal;

  UserData({
    this.id,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  double get bmr {
    // Mifflin-St Jeor Formula
    if (gender == Gender.male) {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  double get tdee {
    return bmr * activityLevel.factor;
  }

  double get dailyCalorieTarget {
    return tdee + goal.calorieAdjustment;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender.toString(),
      'activityLevel': activityLevel.toString(),
      'goal': goal.toString(),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      gender: Gender.values.firstWhere(
        (e) => e.toString() == map['gender'],
      ),
      activityLevel: ActivityLevel.values.firstWhere(
        (e) => e.toString() == map['activityLevel'],
      ),
      goal: GoalType.values.firstWhere(
        (e) => e.toString() == map['goal'],
      ),
    );
  }

  UserData copyWith({
    String? id,
    int? weight,
    int? height,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
    GoalType? goal,
  }) {
    return UserData(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
