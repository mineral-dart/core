import 'dart:isolate';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/contracts/wss/constants/op_code.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/builders/discord_message_builder.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/io/exceptions/token_exception.dart';

final class WebsocketOrchestrator implements WebsocketOrchestratorContract {
  HttpClientContract get _httpClient => ioc.resolve<HttpClientContract>();

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  @override
  final ShardingConfigContract config;

  @override
  final Map<int, Shard> shards = {};

  WebsocketOrchestrator(this.config);

  @override
  void send(String message) {
    if (Isolate.current.debugName == 'dev') {
      final sendPort = ioc.resolve<SendPort?>();
      sendPort?.send(message);
    } else {
      _logger.trace('Sending message to all shards $message');
      shards.forEach((_, shard) => shard.client.send(message));
    }
  }

  @override
  void setBotPresence(List<BotActivity>? activities, StatusType? status, bool? afk) {
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.presenceUpdate)
      ..append('since', DateTime.now().millisecond)
      ..append('activities',
          activities != null ? activities.map((element) => element.toJson()).toList() : [])
      ..append('status', status != null ? status.toString() : StatusType.online.toString())
      ..append('afk', afk ?? false);

    send(message.build());
  }

  @override
  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await _httpClient.get('/gateway/bot');
    return switch (response.statusCode) {
      int() when _httpClient.status.isSuccess(response.statusCode) => response.body,
      int() when _httpClient.status.isError(response.statusCode) =>
        throw TokenException('This token is invalid or expired'),
      _ => throw (response.bodyString),
    };
  }

  @override
  Future<void> createShards(HmrContract? hmr, RunningStrategy strategy) async {
    final {'url': String endpoint, 'shards': int shardCount} = await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final shard = Shard(
          shardName: 'shard #$i',
          url: '$endpoint/?v=${config.version}',
          hmr: hmr,
          wss: this,
          strategy: strategy);

      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }
}
