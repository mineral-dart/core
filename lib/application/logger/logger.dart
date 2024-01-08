import 'package:logging/logging.dart' as logging;

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

    logging.Logger.root.level = logLevels[level.toUpperCase()];
    logging.Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
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
}
