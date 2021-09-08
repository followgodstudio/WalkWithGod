import 'package:flutter_logs/flutter_logs.dart';

class MyLogger {
  final String className;
  MyLogger(this.className);

  void i(String message) {
    FlutterLogs.logInfo(className, className, message);
  }

  void w(String message) {
    FlutterLogs.logWarn(className, className, message);
  }

  void e(String message) {
    FlutterLogs.logError(className, className, message);
  }
}
