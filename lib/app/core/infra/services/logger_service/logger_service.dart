import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

abstract class LoggerService {
  void log(String message);
  void error(exception, {StackTrace? stackTrace});
}

class LoggerServiceImpl implements LoggerService {
  LoggerServiceImpl();

  @override
  void log(String message) {
    if (!kReleaseMode) {
      dev.log('Logged message: $message');
    }
  }

  @override
  void error(exception, {StackTrace? stackTrace}) {
    if (!kReleaseMode) {
      dev.log('Exception: ${exception.toString()}');
      if (stackTrace != null) {
        dev.log('StackTrace: ${stackTrace.toString()}');
      }
    }
  }
}
