import 'dart:isolate';

import 'package:mineral/application/container/ioc_container.dart';
import 'package:mineral/application/environment/app_env.dart';
import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/application/hmr/hot_module_reloading.dart';
import 'package:mineral/application/http/header.dart';
import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

final class Kernel implements KernelContract {
  final SendPort? _devPort;

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

  Kernel(this._devPort,
      {required this.logger,
      required this.environment,
      required this.httpClient,
      required this.config,
      required this.dataListener,
      required this.dataStore}) {
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${config.token}'),
    ]);

    ioc
      ..bind('logger', () => logger)
      ..bind('data_store', () => dataStore);
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
    if (useHmr) {
      final hmr = HotModuleReloading(_devPort, dataStore, dataListener, createShards, shards);
      await hmr.spawn();
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
