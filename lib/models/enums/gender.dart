enum Gender {
  male,
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Мужской';
      case Gender.female:
        return 'Женский';
    }
  }
}
