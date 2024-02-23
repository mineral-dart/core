import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

abstract interface class KernelContract {
  Map<int, Shard> get shards;

  ShardingConfigContract get config;

  LoggerContract get logger;

  EnvironmentContract get environment;

  HttpClientContract get httpClient;

  DataListenerContract get dataListener;

  DataStoreContract get dataStore;

  Future<void> init();
}
