import 'package:logging/logging.dart' as logging;
import 'package:mineral/api.dart';

enum LogLevel implements EnhancedEnum<logging.Level> {
  trace('TRACE', logging.Level.FINEST),
  fatal('FATAL', logging.Level.SHOUT),
  error('ERROR', logging.Level.SEVERE),
  warn('WARN', logging.Level.WARNING),
  info('INFO', logging.Level.INFO);

  final String name;

  @override
  final logging.Level value;

  const LogLevel(this.name, this.value);
}
