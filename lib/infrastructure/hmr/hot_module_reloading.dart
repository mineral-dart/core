import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/infrastructure/data_store/data_store.dart';
import 'package:mineral/infrastructure/hmr/watcher_builder.dart';
import 'package:mineral/infrastructure/hmr/watcher_config.dart';
import 'package:mineral/infrastructure/io/ansi.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

final class HotModuleReloading {
  final WatcherConfig _watcherConfig;
  final SendPort? _devPort;

  String fileLocation = '';
  int fileRefreshCount = 0;

  Isolate? _devIsolate;
  SendPort? devSendPort;
  DateTime? duration;

  final DataStoreContract _datastore;
  final DataListenerContract _dataListener;
  final Map<int, Shard> _shards;
  final Function() _createShards;

  HotModuleReloading(this._devPort, this._watcherConfig, this._datastore, this._dataListener,
      this._createShards, this._shards);

  Future<void> spawn() async {
    if (Isolate.current.debugName == 'dev') {
      final ReceivePort port = ReceivePort();
      final Stream stream = port.asBroadcastStream();

      _devPort!.send(port.sendPort);
      await _datastore.marshaller.cache.init();
      await for (final Map<String, dynamic> message in stream) {
        _dataListener.packets.dispatch(ShardMessageImpl.of(message));
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
        .addWatchFolder(Directory(join(Directory.current.path, 'lib')));

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
    final uri = Uri.parse(join(Directory.current.path, 'lib', 'main.dart'));

    Isolate.spawnUri(Uri.file(uri.path), [], port.sendPort, debugName: 'dev')
        .then((Isolate isolate) async {
      _devIsolate = isolate;
      devSendPort = await port.first;

      _shards.forEach((key, value) {
        final Queue<Map<String, dynamic>> queue = Queue.from(value.onceEventQueue);
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

    final String location = event.path.replaceFirst(Directory.current.path, '').substring(1);
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute}:${now.second}';

    if (fileLocation == location) {
      fileRefreshCount++;
    } else {
      fileLocation = location;
      fileRefreshCount = 1;
    }

    String formatMessage(String action) =>
        '$time ${lightBlue.wrap('[mineral]')} ${lightGreen.wrap('hmr $action')} ${styleDim.wrap(location)} ${yellow.wrap('(x$fileRefreshCount)')}';

    stdout
      ..write('\x1b[0;0H')
      ..write('\x1b[2J');

    final message = switch (event.type) {
      ChangeType.ADD => formatMessage('create'),
      ChangeType.MODIFY => formatMessage('update'),
      ChangeType.REMOVE => formatMessage('delete'),
      _ => '',
    };

    stdout
      ..writeln(message)
      ..writeln();

    _devIsolate?.kill(priority: Isolate.immediate);
    _devIsolate = null;

    _createDevelopmentIsolate();

    if (Platform.isLinux) {
      duration = DateTime.now();
    }
  }
}
