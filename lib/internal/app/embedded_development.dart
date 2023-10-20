import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/watcher/watcher_builder.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger.dart';
import 'package:path/path.dart';
import 'package:watcher/watcher.dart';

final class EmbeddedDevelopment implements EmbeddedApplication {
  final Queue<Map<String, dynamic>> queue = Queue();

  final Environment environment;
  final Logger logger;
  late WebsocketManager websocket;
  late final DiscordHttpClient http;

  DateTime? duration;

  Isolate? _devIsolate;
  SendPort? _devSendPort;

  String get appEnv => environment.get('APP_ENV');
  String get token => environment.get('APP_TOKEN');
  int get intents => int.parse(environment.get('INTENTS'));
  bool get useHmr => bool.parse(environment.get('HMR'));

  EmbeddedDevelopment({ required this.logger, required this.environment, required this.http });

  @override
  void spawn () {
    websocket = WebsocketManager(
      logger: logger.wss,
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
          if(!event.path.endsWith(".dart")) {
            return;
          }

          if (Platform.isLinux && duration != null) {
            if (DateTime.now().difference(duration!) < Duration(milliseconds: 5)) {
              return;
            }
          }

          final String location = makeRelativePath(event.path);

          switch (event.type) {
            case ChangeType.ADD: logger.hmr.info('File added: $location');
            case ChangeType.MODIFY: logger.hmr.info('File modified: $location');
            case ChangeType.REMOVE: logger.hmr.info('File removed: $location');
          }

          _devIsolate?.kill(priority: Isolate.immediate);
          _devIsolate = null;
          createDevelopmentIsolate();

          logger.hmr.info('Restarting application...');

          if (Platform.isLinux) {
            duration = DateTime.now();
          }
       })
        .build();

    watcher.watch();
  }

  void createDevelopmentIsolate () {
    final port = ReceivePort();
    final uri = Uri.parse(join(Directory.current.path, 'bin', 'app.dart'));
    Isolate.spawnUri(uri, [], port.sendPort, debugName: 'dev')
        .then((Isolate isolate) async {
      _devIsolate = isolate;
      _devSendPort = await port.first;

      restoreEvents();
    });
  }

  void dispatch (Map<String, dynamic> response) {
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