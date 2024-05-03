import 'package:mineral/infrastructure/environment/environment.dart';
import 'package:mineral/infrastructure/hmr/hot_module_reloading.dart';
import 'package:mineral/infrastructure/http/http_client.dart';
import 'package:mineral/infrastructure/logger/logger.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/infrastructure/data_store/data_store.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

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
