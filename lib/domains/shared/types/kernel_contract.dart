import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

abstract interface class KernelContract {
  Map<int, Shard> get shards;

  ShardingConfigContract get config;

  HttpClientContract get httpClient;

  DataListenerContract get dataListener;

  Future<void> init();
}
