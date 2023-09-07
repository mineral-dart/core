import 'dart:io';

import 'package:mineral/services/logger/logger_contract.dart';

class Logger implements LoggerContract {
  @override
  void debug(String message) => stdout.writeln(message);

  @override
  void error(String message) => stdout.writeln(message);

  @override
  void info(String message) => stdout.writeln(message);

  @override
  void log(message) => stdout.writeln(message);

  @override
  void success(String message) => stdout.writeln(message);

  @override
  void warning(String message) => stdout.writeln(message);
}