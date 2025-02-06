
enum Gender { male, female }
enum ActivityLevel { low, medium, high }
enum Goal { loss, maintain, gain }

class UserData {
  final int? id;
  final double weight;
  final double height;
  final int age;
  final Gender gender;
  final ActivityLevel activityLevel;
  final Goal goal;
  final double waterGoal;

  UserData({
    this.id,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    this.waterGoal = 2000,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender.toString().split('.').last,
      'activity_level': activityLevel.toString().split('.').last,
      'goal': goal.toString().split('.').last,
      'water_goal': waterGoal,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      gender: Gender.values.firstWhere(
          (e) => e.toString().split('.').last == map['gender']),
      activityLevel: ActivityLevel.values.firstWhere(
          (e) => e.toString().split('.').last == map['activity_level']),
      goal: Goal.values
          .firstWhere((e) => e.toString().split('.').last == map['goal']),
      waterGoal: map['water_goal'],
    );
  }

  double calculateDailyCalories() {
    // Harris-Benedict formula
    double bmr;
    if (gender == Gender.male) {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    // Activity multiplier
    double activityMultiplier;
    switch (activityLevel) {
      case ActivityLevel.low:
        activityMultiplier = 1.2;
      case ActivityLevel.medium:
        activityMultiplier = 1.55;
      case ActivityLevel.high:
        activityMultiplier = 1.725;
    }

    // Goal adjustment
    double goalMultiplier;
    switch (goal) {
      case Goal.loss:
        goalMultiplier = 0.85;
      case Goal.maintain:
        goalMultiplier = 1.0;
      case Goal.gain:
        goalMultiplier = 1.15;
    }

    return bmr * activityMultiplier * goalMultiplier;
  }
}
