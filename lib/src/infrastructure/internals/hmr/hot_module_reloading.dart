import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mansion/mansion.dart';
import 'package:mineral/container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_builder.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:path/path.dart' as path;
import 'package:watcher/watcher.dart';

final class HotModuleReloading {
  final WatcherConfig _watcherConfig;
  final SendPort? _devPort;

  String fileLocation = '';
  int fileRefreshCount = 0;

  Isolate? _devIsolate;
  SendPort? devSendPort;
  DateTime? duration;

  final KernelContract _kernel;
  final Map<int, Shard> _shards;
  final Function() _createShards;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  HotModuleReloading(this._devPort, this._watcherConfig, this._kernel,
      this._createShards, this._shards);

  Future<void> spawn() async {
    if (Isolate.current.debugName == 'dev') {
      final ReceivePort port = ReceivePort();
      final Stream stream = port.asBroadcastStream();

      _devPort!.send(port.sendPort);
      await _marshaller.cache.init();
      await for (final Map<String, dynamic> message in stream) {
        _kernel.packetListener.dispatcher
            .dispatch(ShardMessageImpl.of(message));
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
        .addWatchFolder(Directory(path.join(Directory.current.path, 'src')));

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
    final uri =
        Uri.parse(path.join(Directory.current.path, 'src', 'main.dart'));

    Isolate.spawnUri(Uri.file(uri.path), [], port.sendPort, debugName: 'dev')
        .then((Isolate isolate) async {
      _devIsolate = isolate;
      devSendPort = await port.first;

      _shards.forEach((key, value) {
        final Queue<Map<String, dynamic>> queue =
            Queue.from(value.onceEventQueue);
        while (queue.isNotEmpty) {
          final response = queue.removeFirst();
          devSendPort?.send(response);
        }
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
        event.path.replaceFirst(Directory.current.path, '').substring(1);

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
