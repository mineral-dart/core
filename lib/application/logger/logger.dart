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

  Logger() {
    logging.Logger.root.level = logging.Level.ALL;
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
