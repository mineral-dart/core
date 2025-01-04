import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mansion/mansion.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_builder.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';
import 'package:watcher/watcher.dart';

final class HotModuleReloading implements HmrContract {
  ScaffoldContract get _app => ioc.resolve<ScaffoldContract>();
  WebsocketOrchestratorContract get _wss => ioc.resolve<WebsocketOrchestratorContract>();

  final WatcherConfig _watcherConfig;
  final SendPort? _devPort;

  String fileLocation = '';
  int fileRefreshCount = 0;

  Isolate? _devIsolate;
  SendPort? devSendPort;
  DateTime? duration;

  final KernelContract _kernel;
  final Map<int, ShardContract> _shards;
  final Function() _createShards;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  HotModuleReloading(this._devPort, this._watcherConfig, this._kernel,
      this._createShards, this._shards);

  @override
  void send(Map payload) {
    devSendPort?.send(payload);
  }

  @override
  Future<void> spawn() async {
    if (Isolate.current.debugName == 'dev') {
      final ReceivePort port = ReceivePort();
      final Stream stream = port.asBroadcastStream();

      _devPort!.send(port.sendPort);
      await _marshaller.cache?.init();
      await for (final Map<String, dynamic> message in stream) {
        _kernel.packetListener.dispatcher.dispatch(ShardMessage.of(message));
      }
    } else {
      _createHotModuleLoader();
      _createDevelopmentIsolate();
      _createShards();
    }
  }

  void _createHotModuleLoader() {
    final watcher = WatcherBuilder(Directory.current)
        .setAllowReload(true)
        .addWatchFolder(_app.libDir);

    for (final file in _watcherConfig.watchedFiles) {
      watcher.addWatchFile(file);
    }

    for (final folder in _watcherConfig.watchedFolders) {
      watcher.addWatchFolder(folder);
    }

    watcher.onReload(_handleModify).build().watch();
  }

  void _createDevelopmentIsolate() {
    final port = ReceivePort();

    Isolate.spawnUri(_app.entrypoint.uri, [], port.sendPort, debugName: 'dev')
        .then((Isolate isolate) async {
      _devIsolate = isolate;
      final broadcast = port.asBroadcastStream();
      devSendPort = await broadcast.first;

      _shards.forEach((key, value) {
        final Queue<Map<String, dynamic>> queue = Queue.from(value.onceEventQueue);
        while (queue.isNotEmpty) {
          final response = queue.removeFirst();
          devSendPort?.send(response);
        }
      });

      broadcast.listen((message) {
        _wss.send(WebsocketIsolateMessageTransfert.fromJson(message));
      });
    });
  }

  void _handleModify(WatchEvent event) {
    if (Platform.isLinux && duration != null) {
      if (DateTime.now().difference(duration!) < Duration(milliseconds: 5)) {
        return;
      }
    }

    final String location =
        event.path.replaceFirst(_app.rootDir.path, '').substring(1);

    if (fileLocation == location) {
      fileRefreshCount++;
    } else {
      fileLocation = location;
      fileRefreshCount = 1;
    }

    List<Sequence> formatMessage(String action) => [
          SetStyles(Style.foreground(Logger.primaryColor)),
          Print('hmr $action '),
          SetStyles.reset,
          SetStyles(Style.foreground(Logger.mutedColor)),
          Print(location),
          SetStyles.reset,
          SetStyles(Style.foreground(Color.yellow)),
          Print(' (x$fileRefreshCount)'),
          SetStyles.reset,
          AsciiControl.lineFeed,
        ];

    final message = switch (event.type) {
      ChangeType.ADD => formatMessage('create'),
      ChangeType.MODIFY => formatMessage('update'),
      ChangeType.REMOVE => formatMessage('delete'),
      _ => <Sequence>[],
    };

    stdout.writeAnsiAll(message);

    _devIsolate?.kill(priority: Isolate.immediate);
    _devIsolate = null;

    _createDevelopmentIsolate();

    if (Platform.isLinux) {
      duration = DateTime.now();
    }
  }
}
