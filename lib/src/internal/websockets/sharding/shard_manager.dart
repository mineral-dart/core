import 'dart:async';

import 'package:http/http.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/exceptions/shard_exception.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

import 'package:mineral/api.dart';

class ShardManager {
  final Http http;
  final List<Intent> intents;
  final String _token;

  late final String _gatewayURL;
  late final int maxConcurrency;

  int possibleActions = 0;

  late final Duration identifyTimeout;

  final Map<int, Shard> shards = {};
  final List<int> shardsToStart = [];

  final List<int> identifyQueue = [];

  int totalShards = 0;

  ShardManager(this.http, this._token, this.intents);

  Future<void> start ({ int? shardsCount }) async {
    http.defineHeader(header: 'Authorization', value: 'Bot $_token');
    AuthenticationResponse response = await getBotGateway(Constants.apiVersion);

    _gatewayURL = response.url;
    maxConcurrency = response.maxConcurrency;

    identifyTimeout = Duration(milliseconds: (5000 ~/ maxConcurrency));
    possibleActions = maxConcurrency;

    shardsCount != null
        ? totalShards = shardsCount
        : totalShards = response.shards;

    while(totalShards > shards.length) {
      startShard(shards.length, _gatewayURL);
    }

    Timer.periodic(Duration(milliseconds: 5200), (timer) {
      if(identifyQueue.isEmpty) return;
      for(int i = 0; i < maxConcurrency; i++) {
        final int shardId = identifyQueue[0];

        final Shard? shard = shards[shardId];
        if(shard == null) throw ShardException(prefix: 'Shard #$shardId', cause: 'Shard must exist to be identified');
        shard.identify();

        identifyQueue.removeAt(0);
      }
    });
  }

  Future<AuthenticationResponse> getBotGateway(int version) async {
    Response response = await http.get(url: '/v$version/gateway/bot');
    return AuthenticationResponse.fromResponse(response);
  }

  Future<void> startShard(int id, String gatewayURL) async {
    Console.info(message: 'Starting shard #$id');

    final Shard shard = Shard(this, id, gatewayURL, _token);
    shards.putIfAbsent(id, () => shard);
  }

  Future<void> send(OpCode code, dynamic data) async {
    shards.forEach((key, value) {
      value.send(code, data);
    });
  }
}