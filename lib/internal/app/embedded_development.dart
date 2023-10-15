import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/console/console.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/watcher/watcher_builder.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

final class EmbeddedDevelopment implements EmbeddedApplication {
  final Queue<Map<String, dynamic>> queue = Queue();

  final Environment environment;
  final LoggerContract logger;
  late WebsocketManager websocket;
  late final Console console;
  late final DiscordHttpClient http;

  ReceivePort? _receivedPort;
  Isolate? _devIsolate;
  SendPort? _devSendPort;

  String get appEnv => environment.get('APP_ENV');
  String get token => environment.get('APP_TOKEN');
  int get intents => int.parse(environment.get('INTENTS'));
  bool get useHmr => bool.parse(environment.get('HMR'));

  EmbeddedDevelopment({ required this.logger, required this.environment, required this.http });

  @override
  Future<void> spawn () async {
    websocket = WebsocketManager(
      token: token,
      intents: intents,
      http: http,
      dispatcher: dispatch
    );

    websocket.start(shardCount: 1);

    createHotReLoader();
    createDevelopmentIsolate();
  }

  void createHotReLoader () {
    String makeRelativePath (String path) =>
        path.replaceFirst(Directory.current.path, '').substring(1);

    final watcher = WatcherBuilder(Directory.current)
      .setAllowReload(useHmr)
      .addWatchFolder(Directory(join(Directory.current.path, 'lib')))
      .addWatchFolder(Directory(join(Directory.current.path, 'config')))
      .onReload((event) {
        final String location = makeRelativePath(event.path);

        switch (event.type) {
          case ChangeType.ADD: logger.info('File added: $location');
          case ChangeType.MODIFY: logger.info('File modified: $location');
          case ChangeType.REMOVE: logger.info('File removed: $location');
        }

        _devIsolate?.kill(priority: Isolate.immediate);
        createDevelopmentIsolate();
        logger.info('Restarting application...');
      })
      .build();

    watcher.watch();
  }

  void createDevelopmentIsolate () async {
    _receivedPort = ReceivePort();
    final uri = Uri.parse(join(Directory.current.path, 'bin', 'app.dart'));
    Isolate.spawnUri(uri, [], _receivedPort?.sendPort, debugName: 'dev')
      .then((Isolate isolate) async {
        _devIsolate = isolate;
        _devSendPort = await _receivedPort?.first;

        restoreEvents();
      });
  }

  void dispatch(Map<String, dynamic> response) {
    queue.addLast(response);
    _devSendPort?.send(response);
  }

  void restoreEvents () {
    final Queue<Map<String, dynamic>> queue = Queue.from(this.queue);

    while (queue.isNotEmpty) {
      final response = queue.removeFirst();
      _devSendPort?.send(response);
    }
  }
}