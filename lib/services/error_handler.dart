import 'dart:async';

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = '']);
}

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return _handleException(error);
    } else {
      return 'Произошла неизвестная ошибка';
    }
  }

  static String _handleException(Exception exception) {
    switch (exception.runtimeType) {
      case FormatException:
        return 'Ошибка формата данных';
      case TimeoutException:
        return 'Превышено время ожидания';
      case NetworkException:
        return 'Ошибка сети';
      default:
        return 'Произошла ошибка: ${exception.toString()}';
    }
  }
}
