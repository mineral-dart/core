import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';

abstract class WebsocketOrchestratorContract {
  List<({String uid, List<String> targetKeys, Completer completer})> get requestQueue;

  ShardingConfigContract get config;

  Map<int, ShardContract> get shards;

  void send(WebsocketIsolateMessageTransfert message);

  void setBotPresence(List<BotActivity>? activity, StatusType? status, bool? afk);

  Future<Presence> getMemberPresence(String serverId, String id);

  Future<Map<String, dynamic>> getWebsocketEndpoint();

  Future<void> createShards(HmrContract? hmr, RunningStrategy strategy);
}
