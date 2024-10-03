// ignore_for_file: avoid-dynamic
import 'dart:developer' as dev;
import 'dart:isolate';

import 'package:flutter/foundation.dart';

abstract class LoggerService {
  void log(String message);
  void error(exception, {StackTrace? stackTrace});
}

class LoggerServiceImpl implements LoggerService {
  LoggerServiceImpl() {
    Isolate.current.addErrorListener(isolateErrorListener);
  }

  SendPort get isolateErrorListener {
    return RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      final exception = errorAndStacktrace.first;
      final stackTrace = errorAndStacktrace[1];
      error(exception, stackTrace: stackTrace);
    }).sendPort;
  }

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
      dev.log('StackTrace: ${stackTrace.toString()}');
    }
  }
}
