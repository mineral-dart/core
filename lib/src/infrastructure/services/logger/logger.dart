import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logging/logging.dart' as logging;
import 'package:mansion/mansion.dart';
import 'package:mineral/src/domains/services/logger/log_level.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';

final class Logger implements LoggerContract {
  static Color get primaryColor => Color.fromRGB(140, 169, 238);

  static Color get mutedColor => Color.brightBlack;

  final LogLevel _logLevel;
  final String _dartEnv;

  final _logger = logging.Logger('Core');

  Logger(this._logLevel, this._dartEnv) {
    logging.Logger.root.level = _logLevel.level;

    logging.Logger.root.onRecord.listen((record) {
      final time = '[${DateFormat.Hms().format(record.time)}]';

      List<Sequence> makeMessage(
        String messageType,
        Color messageColor,
        List<Sequence> message,
      ) {
        return [
          SetStyles(Style.foreground(Color.brightBlack)),
          Print(time),
          SetStyles(Style.foreground(messageColor)),
          Print(' $messageType'),
          SetStyles.reset,
          Print(': '),
          ...message,
          SetStyles.reset,
          AsciiControl.lineFeed,
        ];
      }

      final message = switch (record.level) {
        logging.Level.FINEST => makeMessage('trace', Color.white, [
            SetStyles(Style.foreground(Color.brightBlack)),
            Print(record.message)
          ]),
        logging.Level.SHOUT =>
          makeMessage('fatal', Color.brightRed, [Print(record.message)]),
        logging.Level.SEVERE =>
          makeMessage('error', Color.red, [Print(record.message)]),
        logging.Level.WARNING =>
          makeMessage('warn', Color.yellow, [Print(record.message)]),
        logging.Level.INFO => makeMessage(
            'info',
            Color.fromRGB(140, 169, 238),
            [Print(record.message)],
          ),
        _ => makeMessage('unknown', Color.blue, [Print(record.message)]),
      };

      if (_dartEnv == 'production') {
        message.writeWithoutAnsi();
        return;
      }

      if (stdout.supportsAnsiEscapes) {
        stdout.writeAnsiAll(message);
        return;
      }

      message.writeWithoutAnsi();
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

extension on List<Sequence> {
  void writeWithoutAnsi() {
    for (final sequence in this) {
      switch (sequence) {
        case Print(:final text):
          stdout.write(text);
        case AsciiControl(:final writeAnsiString):
          writeAnsiString(stdout);
        default:
      }
    }
  }
}
