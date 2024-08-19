import 'dart:io';
import 'dart:isolate';

import 'package:mansion/mansion.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/domains/events/event_listener.dart';
import 'package:mineral/domains/providers/provider_manager.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/environment/app_env.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart';
import 'package:mineral/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/infrastructure/internals/wss/shard.dart';
import 'package:mineral/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/infrastructure/io/exceptions/token_exception.dart';
import 'package:mineral/infrastructure/services/http/header.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

abstract interface class KernelContract {
  Map<int, Shard> get shards;

  ShardingConfigContract get config;

  LoggerContract get logger;

  EnvContract get environment;

  HttpClientContract get httpClient;

  PacketListenerContract get packetListener;

  EventListenerContract get eventListener;

  ProviderManagerContract get providerManager;

  MarshallerContract get marshaller;

  DataStoreContract get dataStore;

  HotModuleReloading? get hmr;

  CommandInteractionManagerContract get commands;

  Future<void> init();
}

final class Kernel implements KernelContract {
  final _watch = Stopwatch();

  final SendPort? _devPort;

  final WatcherConfig watcherConfig;

  @override
  final Map<int, Shard> shards = {};

  @override
  final ShardingConfigContract config;

  @override
  final LoggerContract logger;

  @override
  final EnvContract environment;

  @override
  final HttpClientContract httpClient;

  @override
  final PacketListenerContract packetListener;

  @override
  final EventListenerContract eventListener;

  @override
  final ProviderManagerContract providerManager;

  @override
  final MarshallerContract marshaller;

  @override
  final DataStoreContract dataStore;

  @override
  HotModuleReloading? hmr;

  @override
  final CommandInteractionManagerContract commands;

  Kernel(
    this._devPort, {
    required this.logger,
    required this.environment,
    required this.httpClient,
    required this.config,
    required this.packetListener,
    required this.eventListener,
    required this.providerManager,
    required this.marshaller,
    required this.dataStore,
    required this.watcherConfig,
    required this.commands,
  }) {
    _watch.start();
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${config.token}'),
    ]);
  }

  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await httpClient.get('/gateway/bot');
    return switch (response.statusCode) {
      int() when httpClient.status.isSuccess(response.statusCode) => response.body,
      int() when httpClient.status.isError(response.statusCode) =>
        throw TokenException('This token is invalid or revocated !'),
      _ => throw TokenException('This token is invalid or revocated !'),
    };
  }

  @override
  Future<void> init() async {
    final useHmr = bool.parse(environment.get(AppEnv.hmr));

    if ((useHmr && Isolate.current.debugName != 'main') || !useHmr) {
      await providerManager.ready();
    }

    if (Isolate.current.debugName == 'main') {
      final packageFile = File(path.join(Directory.current.path, 'pubspec.yaml'));

      final packageFileContent = await packageFile.readAsString();
      final package = loadYaml(packageFileContent);

      final coreVersion = package['dependencies']['mineral'];

      _watch.stop();

      if (useHmr) {
        List<Sequence> buildSubtitle(String key, String value) {
          return [
            const CursorPosition.moveRight(2),
            SetStyles(Style.foreground(Logger.primaryColor)),
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
            SetStyles(Style.foreground(Logger.primaryColor), Style.bold),
            Print('Mineral v4.0.0-dev.1'),
            SetStyles.reset,
            const CursorPosition.moveRight(2),
            SetStyles(Style.foreground(Logger.mutedColor)),
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
      } else {
        stdout.writeAnsiAll([
          CursorPosition.reset,
          Clear.all,
          AsciiControl.lineFeed,
          SetStyles(Style.foreground(Logger.primaryColor), Style.bold),
          Print('Mineral v$coreVersion'),
          SetStyles.reset,
          AsciiControl.lineFeed,
        ]);
        // '${lightBlue.wrap('mineral v$coreVersion')} ${green.wrap('is running for production…')}');
      }
    }

    if (useHmr) {
      hmr = HotModuleReloading(_devPort, watcherConfig, this, createShards, shards);
      await hmr?.spawn();
    } else {
      createShards();
    }
  }

  Future<void> createShards() async {
    final {'url': String endpoint, 'shards': int shardCount} = await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final shard =
          Shard(shardName: 'shard #$i', url: '$endpoint/?v=${config.version}', kernel: this);
      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }
}
