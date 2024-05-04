import 'dart:io';
import 'dart:isolate';

import 'package:mineral/domains/environment/app_env.dart';
import 'package:mineral/domains/environment/environment.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/hmr/hot_module_reloading.dart';
import 'package:mineral/infrastructure/hmr/watcher_config.dart';
import 'package:mineral/infrastructure/io/ansi.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/infrastructure/internals/wss/shard.dart';
import 'package:mineral/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/infrastructure/services/http/header.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

final class Kernel implements KernelContract {
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
  final DataListenerContract dataListener;

  @override
  final DataStoreContract dataStore;

  @override
  HotModuleReloading? hmr;

  Kernel(this._devPort,
      {required this.logger,
      required this.environment,
      required this.httpClient,
      required this.config,
      required this.dataListener,
      required this.dataStore,
      required this.watcherConfig}) {
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${config.token}'),
    ]);

    ioc
      ..bind('logger', () => logger)
      ..bind('datastore', () => dataStore);
  }

  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await httpClient.get('/gateway/bot');
    return switch (response.statusCode) {
      200 => response.body,
      401 => throw Exception('This token is invalid or revocated !'),
      _ => throw Exception(response.body['message']),
    };
  }

  @override
  Future<void> init() async {
    final useHmr = environment.get<bool>(AppEnv.hmr);

    if (Isolate.current.debugName == 'main') {
      final packageFile = File(join(Directory.current.path, 'pubspec.yaml'));

      final packageFileContent = await packageFile.readAsString();
      final package = loadYaml(packageFileContent);

      final coreVersion = package['dependencies']['mineral'];

      if (useHmr) {
        stdout
          ..write('\x1b[0;0H')
          ..write('\x1b[2J')
          ..writeln('${lightBlue.wrap('mineral v$coreVersion')} ${green.wrap('hmr running…')}')
          ..writeln('> Github : https://github.com/mineral-dart')
          ..writeln('> Discord : https://discord.gg/JKj2FwEf3b')
          ..writeln();
      } else {
        stdout.writeln('${lightBlue.wrap('mineral v$coreVersion')} ${green.wrap('is running for production…')}');
      }
    }

    if (useHmr) {
      hmr = HotModuleReloading(
          _devPort, watcherConfig, dataStore, dataListener, createShards, shards);
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
