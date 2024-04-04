import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/application/hmr/watcher_builder.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/shard_message.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

final class HotModuleReloading {
  final SendPort? _devPort;

  Isolate? _devIsolate;
  SendPort? _devSendPort;
  DateTime? duration;

  final DataStoreContract _datastore;
  final DataListenerContract _dataListener;
  final Map<int, Shard> _shards;
  final Function() _createShards;

  HotModuleReloading(this._devPort, this._datastore, this._dataListener, this._createShards, this._shards);

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
    WatcherBuilder(Directory.current)
        .setAllowReload(true)
        .addWatchFolder(Directory(join(Directory.current.path, 'lib')))
        .onReload(_handleModify)
        .build()
        .watch();
  }

  void _createDevelopmentIsolate() {
    final port = ReceivePort();
    final uri = Uri.parse(join(Directory.current.path, 'lib', 'main.dart'));

    Isolate.spawnUri(Uri.file(uri.path), [], port.sendPort, debugName: 'dev')
        .then((Isolate isolate) async {
      _devIsolate = isolate;
      _devSendPort = await port.first;

      _shards.forEach((key, value) {
        final Queue<Map<String, dynamic>> queue = Queue.from(value.onceEventQueue);
        while (queue.isNotEmpty) {
          final response = queue.removeFirst();
          _devSendPort?.send(response);
        }
      });
    });
  }

  void _handleModify(WatchEvent event) {
    if (!event.path.endsWith('.dart')) {
      return;
    }

    if (Platform.isLinux && duration != null) {
      if (DateTime.now().difference(duration!) < Duration(milliseconds: 5)) {
        return;
      }
    }

    final String location = event.path.replaceFirst(Directory.current.path, '').substring(1);

    switch (event.type) {
      case ChangeType.ADD:
        print('File added: $location');
      case ChangeType.MODIFY:
        print('File modified: $location');
      case ChangeType.REMOVE:
        print('File removed: $location');
    }

    _devIsolate?.kill(priority: Isolate.immediate);
    _devIsolate = null;

    _createDevelopmentIsolate();

    print('Restarting application...');

    if (Platform.isLinux) {
      duration = DateTime.now();
    }
  }
}
