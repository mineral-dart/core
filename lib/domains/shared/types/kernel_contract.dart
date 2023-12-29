import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/domains/events/event_manager.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

abstract interface class KernelContract {
  Map<int, Shard> get shards;

  ShardingConfigContract get config;

  HttpClientContract get httpClient;

  EventManagerContract get eventManager;

  Future<void> init();
}
