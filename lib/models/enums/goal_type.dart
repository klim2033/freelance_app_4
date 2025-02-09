enum GoalType {
  lose,
  maintain,
  gain;

  String get displayName {
    switch (this) {
      case GoalType.lose:
        return 'Снижение веса';
      case GoalType.maintain:
        return 'Поддержание веса';
      case GoalType.gain:
        return 'Набор веса';
    }
  }

  double get calorieAdjustment {
    switch (this) {
      case GoalType.lose:
        return -500; // Deficit for weight loss
      case GoalType.maintain:
        return 0;
      case GoalType.gain:
        return 500; // Surplus for weight gain
    }
  }
}
