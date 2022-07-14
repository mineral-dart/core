library console;

import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';

class Console {
  static void log ({ required String message, String level = 'info'}) {
    if (level == 'debug') {
      final Environment environment = ioc.singleton(ioc.services.environment);
      final String? logLevel = environment.get('LOG_LEVEL');

      if (logLevel != 'debug') return;
    }

    print(message);
  }

  static debug ({ String prefix = 'debug', required String message }) {
    ReporterManager? reporter = ioc.singleton(ioc.services.reporter);

    if (reporter != null && reporter.reportLevel == 'debug') {
      _report('[ $prefix ] $message');
    }

    String p = ColorList.white(prefix);
    log(message: '[ $p ] $message', level: 'debug');
  }

  static info ({ String prefix = 'info', required String message }) {
    String p = ColorList.blue(prefix);
    log(message: '[ $p ] $message', level: 'info');
    _report('[ $prefix ] $message');
  }

  static success ({ String prefix = 'success', required String message }) {
    String p = ColorList.green(prefix);
    log(message: '[ $p ] $message', level: 'info');
    _report('[ $prefix ] $message');
  }

  static error ({ String prefix = 'error', required String message }) {
    log(message: getErrorMessage(prefix: ColorList.red(prefix), message: message), level: 'error');
    _report('[ $prefix ] $message');
  }

  static warn ({ String prefix = 'warn', required String message }) {
    log(message: getWarnMessage(prefix: ColorList.yellow(prefix), message: message), level: 'warn');
    _report('[ $prefix ] $message');
  }

  static String getWarnMessage ({ String? prefix = 'warn', required String message }) {
    String p = ColorList.yellow(prefix!);
    return '[ $p ] $message';
  }

  static String getErrorMessage ({ String? prefix = 'error', required String message }) {
    String p = ColorList.red(prefix!);
    return '[ $p ] $message';
  }

  static _report (String message) {
    ReporterManager? reporter = ioc.singleton(ioc.services.reporter);
    if (reporter != null) {
      reporter.write(message);
    }
  }
}

class ColorList {
  static String black (String text) => '\x1B[30m$text\x1B[0m';
  static String red (String text) => '\x1B[186m$text\x1B[0m';
  static String green (String text) => '\x1B[32m$text\x1B[0m';
  static String yellow (String text) => '\x1B[33m$text\x1B[0m';
  static String blue (String text) => '\x1B[34m$text\x1B[0m';
  static String magenta (String text) => '\x1B[35m$text\x1B[0m';
  static String cyan (String text) => '\x1B[36m$text\x1B[0m';
  static String white (String text) => '\x1B[37m$text\x1B[0m';
}
