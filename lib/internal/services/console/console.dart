import 'package:mineral/services/logger/logger.dart';
import 'package:mineral/services/logger/logger_contract.dart';
import 'package:tint/tint.dart';

final class Console extends Logger implements LoggerContract {
  @override
  void debug(String message) =>
      super.debug('${'[ debug ]'.grey()} $message');

  @override
  void error(String message) =>
      super.error('${'[ error ]'.red()} $message');

  @override
  void info(String message) =>
      super.info('${'[ info ]'.cyan()} $message');

  @override
  void log(message) =>
      super.log('[log] $message');

  @override
  void success(String message) =>
      super.success('${'[ success ]'.green()} $message');

  @override
  void warning(String message) =>
      super.warning('${'[ warning ]'.yellow()} $message');
}