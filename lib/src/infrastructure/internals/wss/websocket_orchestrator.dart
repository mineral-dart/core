import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/builders/discord_message_builder.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';
import 'package:mineral/src/infrastructure/io/exceptions/token_exception.dart';

final class WebsocketOrchestrator implements WebsocketOrchestratorContract {
  @override
  final List<({String uid, List<String> targetKeys, Completer completer})>
      requestQueue = [];

  HttpClientContract get _httpClient => ioc.resolve<HttpClientContract>();

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  @override
  final ShardingConfigContract config;

  @override
  final Map<int, Shard> shards = {};

  WebsocketOrchestrator(this.config);

  @override
  void send(WebsocketIsolateMessageTransfert message) {
    if (Isolate.current.debugName == 'development') {
      final sendPort = ioc.resolve<SendPort?>();

      if (message case WebsocketIsolateMessageTransfert(:final type)
          when type == MessageTransfertType.request) {
        _logger.trace('Sending message to all shards ${message.toJson()}');
        requestQueue.add((
          uid: message.uid!,
          targetKeys: message.targetKeys,
          completer: message.completer!
        ));
      }

      sendPort?.send(message.toJson());
    } else {
      _logger.trace('Sending message to all shards ${message.toJson()}');

      return switch (message.type) {
        MessageTransfertType.send => _sendToShards(message),
        MessageTransfertType.request => _requestMessage(message),
        _ => _logger.warn('Unknown message transfert type ${message.type}'),
      };
    }
  }

  void _sendToShards(WebsocketIsolateMessageTransfert message) {
    shards.forEach(
      (_, shard) => shard.client.send(json.encode(message.payload)),
    );
  }

  void _requestMessage(WebsocketIsolateMessageTransfert message) {
    if (Isolate.current.debugName == 'main' &&
        env.get(AppEnv.dartEnv) == 'production') {
      requestQueue.add((
        uid: message.uid!,
        targetKeys: message.targetKeys,
        completer: message.completer!
      ));
    }

    _sendToShards(message);
  }

  @override
  void setBotPresence(
      List<BotActivity>? activities, StatusType? status, bool? afk) {
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.presenceUpdate)
      ..append('since', DateTime.now().millisecond)
      ..append(
        'activities',
        activities != null
            ? activities.map((element) => element.toJson()).toList()
            : [],
      )
      ..append(
        'status',
        status != null ? status.toString() : StatusType.online.toString(),
      )
      ..append('afk', afk ?? false);

    send(WebsocketIsolateMessageTransfert.send(message.toJson()));
  }

  @override
  Future<Presence> getMemberPresence(String serverId, String id) {
    final completer = Completer<Presence>();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final message = ShardMessageBuilder()
      ..setOpCode(OpCode.requestGuildMember)
      ..append('guild_id', serverId)
      ..append('user_ids', id)
      ..append('presences', true)
      ..append('nonce', timestamp.toString());

    final messageTransfert = WebsocketIsolateMessageTransfert.request(
      payload: message.toJson(),
      uid: timestamp.toString(),
      completer: completer,
      targetKeys: ['presences'],
    );

    send(messageTransfert);

    return completer.future;
  }

  @override
  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final request = Request.json(endpoint: '/gateway/bot');
    final response = await _httpClient.get(request);

    return switch (response.statusCode) {
      int() when _httpClient.status.isSuccess(response.statusCode) =>
        response.body,
      int() when _httpClient.status.isError(response.statusCode) =>
        throw TokenException('This token is invalid or expired'),
      _ => throw (response.bodyString),
    };
  }

  @override
  Future<void> createShards(RunningStrategy strategy) async {
    final {'url': String endpoint, 'shards': int shardCount} =
        await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final url =
          '$endpoint/?v=${config.version}&encoding=${config.encoding.encoder.value}';

      final shard = Shard(
        shardName: 'shard #$i',
        url: url,
        wss: this,
        strategy: strategy,
      );

      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }
}
