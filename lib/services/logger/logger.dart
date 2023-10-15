import 'package:mineral/api/common/collection.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:logging/logging.dart' as logging;
import 'package:mineral/services/logger/logger_mode.dart';

class Logger extends Injectable {
  final Collection<LoggerMode, logging.Logger> _loggers = Collection()
    ..putIfAbsent(LoggerMode.hmr, () => logging.Logger('Hot Module Reloading'))
    ..putIfAbsent(LoggerMode.http, () => logging.Logger('Http'))
    ..putIfAbsent(LoggerMode.wss, () => logging.Logger('Websocket'))
    ..putIfAbsent(LoggerMode.app, () => logging.Logger('Application'))
    ..putIfAbsent(LoggerMode.console, () => logging.Logger('Console'));

  logging.Logger get hmr => _loggers.get(LoggerMode.hmr)!;
  logging.Logger get http => _loggers.get(LoggerMode.http)!;
  logging.Logger get wss => _loggers.get(LoggerMode.wss)!;
  logging.Logger get app => _loggers.get(LoggerMode.app)!;
  logging.Logger get console => _loggers.get(LoggerMode.console)!;

  setRootLogLevel (logging.Level level) {
    logging.Logger.root.level = level;
  }

  void setRootListener (void Function(logging.LogRecord)? callback) {

    logging.Logger.root.onRecord.listen(callback ?? (logging.LogRecord record) {
      print('${record.loggerName} - ${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}