import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class MyLogger extends Logger {
  MyLogger(String className) : super(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    println(color("$emoji" +
        DateFormat('hh:mm:ss').format(DateTime.now()) +
        " [$className] " +
        event.message));
  }
}
