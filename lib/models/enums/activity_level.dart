enum ActivityLevel {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case ActivityLevel.low:
        return 'Низкая активность';
      case ActivityLevel.medium:
        return 'Средняя активность';
      case ActivityLevel.high:
        return 'Высокая активность';
    }
  }

  double get factor {
    switch (this) {
      case ActivityLevel.low:
        return 1.2;
      case ActivityLevel.medium:
        return 1.55;
      case ActivityLevel.high:
        return 1.725;
    }
  }
}
