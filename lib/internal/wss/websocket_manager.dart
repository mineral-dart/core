import 'dart:collection';

import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:mineral/internal/wss/op_code.dart';
import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/wss/shard.dart';

final class WebsocketManager {
  final EmbeddedApplication application;
  final Map<int, Shard> shards = {};

  final String token;
  final Intents intents;

  final DiscordHttpClient http;
  final Queue<int> waitingIdentifyQueue = Queue();
  int totalShards = 0;

  late final String _gatewayUrl;

  /// Max concurrency correspond to the maximum of connection to the gateway in all 5 seconds.
  /// See [Discord Docs](https://discord.com/developers/docs/topics/gateway#session-start-limit-object)
  late final int _maxConcurrency;

  late final Duration _identifyTimeout;

  WebsocketManager({ required this.application, required this.http, required this.token, required this.intents });

  /// Get the bot gateway
  Future _getBotGateway () async => Either.future(
    future: http.get('/gateway/bot').build(),
    onSuccess: (result) => result.body,
    onError: (error) => switch (error.statusCode) {
      401 => throw Exception('Your token is invalid'),
      _ => throw Exception('(${error.statusCode}) ${error.message}')
    }
  );

  Future<void> start ({ required int? shardCount }) async {
    final { 'url': url, 'session_start_limit': session, 'shards': shards } = await _getBotGateway();
    final { 'max_concurrency': maxConcurrency, 'remaining': remaining, 'reset_after': resetAfter } = session;

    _gatewayUrl = url;
    _maxConcurrency = maxConcurrency;

    final int timeoutDuration = 5000 ~/ _maxConcurrency;
    _identifyTimeout = Duration(milliseconds: timeoutDuration);

    shardCount != null
      ? totalShards = shardCount
      : totalShards = shards;

    createShards();
  }

  void createShards () {
    for (int i = 0; i < totalShards; i++) {
      _startShard(i);
    }
  }

  void send({ required OpCode code, required dynamic payload }) {
    for (final shard in shards.values) {
      shard.send(code: code, payload: payload);
    }
  }

  void _startShard (int id) {
    final Shard shard = Shard(this, application, id, _gatewayUrl);
    shards.putIfAbsent(id, () => shard);
  }
}