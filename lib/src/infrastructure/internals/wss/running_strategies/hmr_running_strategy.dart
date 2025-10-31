import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:glob/glob.dart';
import 'package:hmr/hmr.dart';
import 'package:mansion/mansion.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/packets/packet_dispatcher.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:path/path.dart' as path;

final class HmrRunningStrategy implements RunningStrategy {
  WebsocketOrchestratorContract get _wss =>
      ioc.resolve<WebsocketOrchestratorContract>();

  final SendPort? _devPort;
  final PacketDispatcherContract _packetDispatcher;
  final List<Glob> _watchedFiles;

  late final Runner _runner;
  (File, int)? lastFileChanged;

  HmrRunningStrategy(this._devPort, this._packetDispatcher, this._watchedFiles);

  @override
  Future<void> init(RunningStrategyFactory createShards) async {
    if (Isolate.current.debugName == 'main') {
      final mainFile = File(
        path.joinAll([Directory.current.path, 'bin', 'main.dart']),
      );
      final tempDirectory = await Directory.systemTemp.createTemp();

      _runner = Runner(
        entrypoint: mainFile,
        tempDirectory: tempDirectory,
        isolateName: 'development',
      );

      final dateTime = DateTime.now();

      Watcher(
        middlewares: [
          IgnoreMiddleware(['~', '.dart_tool', '.git', '.idea', '.vscode']),
          IncludeMiddleware([Glob('**.dart'), ..._watchedFiles]),
          DebounceMiddleware(Duration(milliseconds: 50), dateTime),
        ],
        onStart: handleStart,
        onFileChange: handleModify,
      ).watch();

      await _runner.run();

      _runner.listen((message) {
        _wss.send(WebsocketIsolateMessageTransfert.fromJson(message));
      });

      await createShards(this);
    } else {
      final ReceivePort port = ReceivePort();
      final Stream stream = port.asBroadcastStream();
      _devPort!.send(port.sendPort);

      await for (final Map<String, dynamic> message in stream) {
        _packetDispatcher.dispatch(ShardMessage.of(message));
      }
    }
  }

  @override
  Future<void> dispatch(WebsocketMessage message) async {
    final strategy = _wss.config.encoding;
    final decoded = strategy.decode(message);

    await _runner.send(decoded.content.serialize());
  }

  Future<void> handleStart() async {
    final List<Sequence> sequences = [
      const CursorPosition.moveTo(0, 0),
      Clear.afterCursor,
      Clear.allAndScrollback,
      SetStyles(Style.foreground(Color.green)),
      Print('[hmr]'),
      Print(' wait to watch changes...'),
      SetStyles.reset,
      AsciiControl.lineFeed
    ];

    stdout.writeAnsiAll(sequences);
  }

  Future<void> handleModify(int eventType, File file) async {
    lastFileChanged = (
      file,
      file.path != lastFileChanged?.$1.path ? 0 : lastFileChanged!.$2 + 1
    );

    final action = switch (eventType) {
      FileSystemEvent.create => 'created',
      FileSystemEvent.modify => 'modified',
      FileSystemEvent.delete => 'deleted',
      FileSystemEvent.move => 'moved',
      _ => 'changed'
    };

    final List<Sequence> sequences = [
      const CursorPosition.moveTo(0, 0),
      Clear.afterCursor,
      Clear.allAndScrollback,
      SetStyles(Style.foreground(Color.green)),
      Print('[hmr] $action '),
      SetStyles(Style.foreground(Color.brightBlack)),
      Print(file.path.replaceFirst('${Directory.current.path}/', '')),
      SetStyles.reset
    ];

    if (lastFileChanged?.$2 != 0) {
      sequences.addAll([
        SetStyles(Style.foreground(Color.yellow)),
        Print(' (x${lastFileChanged!.$2})'),
        SetStyles.reset,
      ]);
    }

    sequences.add(AsciiControl.lineFeed);

    stdout.writeAnsiAll(sequences);
    await _runner.reload();
  }
}
