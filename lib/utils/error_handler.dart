import 'dart:async';

import 'package:flutter/material.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return _handleException(error);
    } else {
      return 'Произошла неизвестная ошибка';
    }
  }

  static String _handleException(Exception exception) {
    // Add specific exception handling here
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

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Ошибка сети']);

  @override
  String toString() => message;
}
