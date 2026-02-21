import 'package:logging/logging.dart';
import 'package:mineral/api.dart';

enum LogLevel implements EnhancedEnum<String>, Enumerable<String> {
  trace('TRACE', Level.FINEST),
  fatal('FATAL', Level.SHOUT),
  error('ERROR', Level.SEVERE),
  warn('WARN', Level.WARNING),
  info('INFO', Level.INFO);

  @override
  final String value;

  final Level level;

  const LogLevel(this.value, this.level);
}
