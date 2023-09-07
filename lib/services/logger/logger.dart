import 'dart:io';

import 'package:mineral/services/logger/logger_contract.dart';

class Logger implements LoggerContract {
  @override
  void debug(message) => stdout.writeln(message);

  @override
  void error(message) => stdout.writeln(message);

  @override
  void info(message) => stdout.writeln(message);

  @override
  void log(message) => stdout.writeln(message);

  @override
  void success(message) => stdout.writeln(message);

  @override
  void warning(message) => stdout.writeln(message);
}