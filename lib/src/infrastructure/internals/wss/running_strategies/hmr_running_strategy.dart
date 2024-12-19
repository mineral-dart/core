import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:mansion/mansion.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart' as services;
import 'package:mineral/src/domains/commons/utils/file.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:path/path.dart' as path;

final class HmrRunningStrategy implements RunningStrategy {
  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  final Stopwatch _watch;
  final HmrContract hmr;

  HmrRunningStrategy(this._watch, this.hmr) {
    _logger.trace('HMR strategy initialized');
  }

  @override
  Future<void> init() async {
    if (Isolate.current.debugName == 'main') {
      final packageFile = File(path.join(Directory.current.path, 'pubspec.yaml'));
      final package = await packageFile.readAsYaml();

      final coreVersion = package['dependencies']['mineral'];

      _watch.stop();

      List<Sequence> buildSubtitle(String key, String value) {
        return [
          const CursorPosition.moveRight(2),
          SetStyles(Style.foreground(services.Logger.primaryColor)),
          Print('➜  '),
          SetStyles(Style.foreground(Color.white), Style.bold),
          Print('$key: '),
          SetStyles.reset,
          Print(value),
        ];
      }

      stdout
        ..writeAnsiAll([
          CursorPosition.reset,
          Clear.all,
          AsciiControl.lineFeed,
          const CursorPosition.moveRight(2),
          SetStyles(Style.foreground(services.Logger.primaryColor), Style.bold),
          Print('Mineral v$coreVersion'),
          SetStyles.reset,
          const CursorPosition.moveRight(2),
          SetStyles(Style.foreground(services.Logger.mutedColor)),
          Print('ready in '),
          SetStyles(Style.foreground(Color.white)),
          Print('${_watch.elapsedMilliseconds} ms'),
          SetStyles.reset,
          AsciiControl.lineFeed,
          AsciiControl.lineFeed,
        ])
        ..writeAnsiAll([
          ...buildSubtitle('Github', 'https://github.com/mineral-dart'),
          AsciiControl.lineFeed,
          ...buildSubtitle('Docs', 'https://mineral-foundation.org'),
          SetStyles.reset,
          AsciiControl.lineFeed,
          AsciiControl.lineFeed,
        ]);
    }

    await hmr.spawn();
  }

  @override
  void dispatch(WebsocketMessage message) {
    hmr.send(json.decode(message.originalContent));
  }
}
