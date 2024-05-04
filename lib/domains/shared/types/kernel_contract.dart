import 'package:mineral/domains/environment/environment.dart';
import 'package:mineral/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/infrastructure/internals/wss/shard.dart';
import 'package:mineral/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class KernelContract {
  Map<int, Shard> get shards;

  ShardingConfigContract get config;

  LoggerContract get logger;

  EnvContract get environment;

  HttpClientContract get httpClient;

  DataListenerContract get dataListener;

  DataStoreContract get dataStore;

  HotModuleReloading? get hmr;

  Future<void> init();
}
