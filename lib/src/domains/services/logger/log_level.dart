import 'package:env_guard/env_guard.dart';
import 'package:logging/logging.dart' as logging;
import 'package:mineral/api.dart';

enum LogLevel implements EnhancedEnum<String>, Enumerable<String> {
  trace('TRACE', logging.Level.FINEST),
  fatal('FATAL', logging.Level.SHOUT),
  error('ERROR', logging.Level.SEVERE),
  warn('WARN', logging.Level.WARNING),
  info('INFO', logging.Level.INFO);

  @override
  final String value;

  final logging.Level level;

  const LogLevel(this.value, this.level);
}
