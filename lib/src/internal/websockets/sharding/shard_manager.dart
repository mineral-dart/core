import 'dart:async';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/exceptions/shard_exception.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';
import 'package:mineral_ioc/ioc.dart';

/// ShardManager is the bridge between the application and the shards [Shard].
/// It manage shards launching, number of shards needed, identify queue (to avoid rate limiting).
///
/// {@category Internal}
class ShardManager extends MineralService {
  final HttpService http;
  final List<Intent> intents;
  final String _token;

  late final String _gatewayURL;
  /// Max concurrency correspond to the maximum of connection to the gateway in all 5 seconds.
  /// See [Discord Docs](https://discord.com/developers/docs/topics/gateway#session-start-limit-object)
  late final int maxConcurrency;

  late final Duration identifyTimeout;

  final Map<int, Shard> shards = {};
  int totalShards = 0;

  final List<int> identifyQueue = [];

  /// Init new ShardManager instance.
  /// HTTP is needed to get websocket URL.
  ShardManager(this.http, this._token, this.intents): super(inject: true);

  /// Define the number of shards to start.
  ///
  /// It's possible to define the number of shards with SHARDS_COUNT environment variable. If no
  /// number is provided, we use [Discord recommendations](https://discord.com/developers/docs/topics/gateway#get-gateway-bot)
  Future<void> start ({ int? shardsCount }) async {
    http.defineHeader(header: 'Authorization', value: 'Bot $_token');
    AuthenticationResponse response = await getBotGateway(Constants.apiVersion);

    _gatewayURL = response.url;
    maxConcurrency = response.maxConcurrency;

    identifyTimeout = Duration(milliseconds: (5000 ~/ maxConcurrency));

    shardsCount != null
      ? totalShards = shardsCount
      : totalShards = response.shards;

    while (totalShards > shards.length) {
      _startShard(shards.length, _gatewayURL);
    }

    if (totalShards >= 2) {
      Timer.periodic(Duration(milliseconds: 5200), (timer) {
        if (identifyQueue.isEmpty) return;

        for (int i = 0; i < maxConcurrency; i++) {
          final int shardId = identifyQueue[0];

          final Shard? shard = shards[shardId];
          if(shard == null) throw ShardException('Shard #$shardId : shard must exist to be identified');
          shard.identify();

          identifyQueue.removeAt(0);
        }
      });
    }
  }

  Future<AuthenticationResponse> getBotGateway(int version) async {
    Response response = await http.get(url: '/v$version/gateway/bot');
    return AuthenticationResponse.fromResponse(response);
  }

  /// Start a new shard
  Future<void> _startShard(int id, String gatewayURL) async {
    final Shard shard = Shard(this, id, gatewayURL, _token);
    shards.putIfAbsent(id, () => shard);
  }

  /// Send a message to all shards
  Future<void> send(OpCode code, dynamic data) async {
    shards.forEach((key, value) {
      value.send(code, data);
    });
  }

  int getLatency() {
    int latency = 0;
    shards.forEach((key, value) {
      latency += value.latency;
    });

    return latency ~/ shards.length;
  }
}