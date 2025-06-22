import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:mansion/mansion.dart';
import 'package:mineral/services.dart' as services;
import 'package:mineral/src/domains/commons/utils/file.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/domains/services/kernel.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:path/path.dart' as path;

final class DefaultRunningStrategy implements RunningStrategy {
  final KernelContract kernel;
  final FutureOr<void> Function() onStartup;

  DefaultRunningStrategy(this.kernel, this.onStartup) {
    kernel.logger.trace('Default strategy initialized');
  }

  @override
  Future<void> init() async {
    if (Isolate.current.debugName == 'main') {
      final packageFile =
          File(path.join(Directory.current.path, 'pubspec.yaml'));
      final package = await packageFile.readAsYaml();

      final coreVersion = package['dependencies']['mineral'];

      stdout.writeAnsiAll([
        CursorPosition.reset,
        Clear.all,
        AsciiControl.lineFeed,
        SetStyles(Style.foreground(services.Logger.primaryColor), Style.bold),
        Print('Mineral v$coreVersion'),
        SetStyles.reset,
        AsciiControl.lineFeed,
      ]);
    }

    onStartup();
  }

  @override
  void dispatch(WebsocketMessage payload) {
    kernel.packetListener.dispatcher.dispatch(payload.content);
  }
}
