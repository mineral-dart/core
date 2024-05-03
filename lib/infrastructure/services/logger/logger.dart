import 'dart:io';

import 'package:logging/logging.dart' as logging;
import 'package:mineral/infrastructure/container/ioc_container.dart';
import 'package:mineral/infrastructure/io/ansi.dart';

abstract interface class LoggerContract {
  void trace(Object message);
  void fatal(Exception message);
  void error(String message);
  void warn(String message);
  void info(String message);
}

final class Logger implements LoggerContract {
  final _logger = logging.Logger('Core');

  Logger(String level) {
    const logLevels = {
      'TRACE': logging.Level.FINEST,
      'FATAL': logging.Level.SHOUT,
      'ERROR': logging.Level.SEVERE,
      'WARN': logging.Level.WARNING,
      'INFO': logging.Level.INFO,
    };

    final bool logLevel = logLevels.keys.contains(level.toUpperCase());
    if (!logLevel) {
      throw Exception('Invalid LOG_LEVEL environment variable, please include in ${logLevels.keys.map((e) => e.toLowerCase())}');
    }
    // [08:23:52.148] INFO (pid): message

    logging.Logger.root.level = logLevels[level.toUpperCase()];
    logging.Logger.root.onRecord.listen((record) {
      final time = '[${record.time.hour}:${record.time.minute}:${record.time.second}.${record.time.millisecond}]';
      final datetime = '[${record.time}]';

      final message = switch(record.level) {
        logging.Level.FINEST => '$datetime ${lightBlue.wrap('TRACE')} : ${styleDim.wrap(record.message)}',
        logging.Level.SHOUT => '$time ${backgroundRed.wrap('FATAL')} : ${lightCyan.wrap(record.message)}',
        logging.Level.SEVERE => '$datetime ${red.wrap('ERROR')} : ${lightCyan.wrap(record.message)}',
        logging.Level.WARNING => '$datetime ${yellow.wrap('WARN')} : ${lightCyan.wrap(record.message)}',
        logging.Level.INFO => '$time ${lightGreen.wrap('INFO')} : ${lightCyan.wrap(record.message)}',
        _ => 'UNKNOWN: ${record.time}: ${record.message}'
      };

      stdout.writeln(message);
    });
  }

  @override
  void error(String message) => _logger.severe(message);

  @override
  void fatal(Exception message) => _logger.shout(message);

  @override
  void info(String message) => _logger.info(message);

  @override
  void trace(Object message) => _logger.finest(message);

  @override
  void warn(String message) => _logger.warning(message);

  factory Logger.singleton() => ioc.resolve('logger');
}
