import 'dart:io';

import 'package:mineral/services/logger/logger_contract.dart';
import 'package:tint/tint.dart';

class Logger implements LoggerContract {
  @override
  void debug(String message) =>
      stdout.writeln('${'[ debug ]'.grey()} $message');

  @override
  void error(String message) =>
      stdout.writeln('${'[ error ]'.red()} $message');

  @override
  void info(String message) =>
      stdout.writeln('${'[ info ]'.cyan()} $message');

  @override
  void log(message) =>
      stdout.writeln('[log] $message');

  @override
  void success(String message) =>
      stdout.writeln('${'[ success ]'.green()} $message');

  @override
  void warning(String message) =>
      stdout.writeln('${'[ warning ]'.yellow()} $message');
}