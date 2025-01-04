import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';

abstract class WebsocketOrchestratorContract {
  ShardingConfigContract get config;

  Map<int, ShardContract> get shards;

  void send(String message);

  void setBotPresence(List<BotActivity>? activity, StatusType? status, bool? afk);

  Future<Map<String, dynamic>> getWebsocketEndpoint();

  Future<void> createShards(HmrContract? hmr, RunningStrategy strategy);
}
