import 'dart:async';

import 'package:http/http.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class ShardManager {
    final Http http;
    final String _token;

    late final String _gatewayURL;
    late final int maxConcurrency;
    
    final Map<int, Shard> shards = {};
    final List<int> shardsToStart = [];

    int totalShards = 0;
    
    late final Timer shardLauncher;

    ShardManager(this.http, this._token);

    Future<void> start ({ int? shardsCount }) async {
        http.defineHeader(header: 'Authorization', value: "Bot $_token");
        AuthenticationResponse response = await getBotGateway(Constants.apiVersion);

        _gatewayURL = response.url;
        maxConcurrency = response.maxConcurrency;

        shardsCount != null
            ? totalShards = shardsCount
            : totalShards = response.shards;

        while(totalShards > shardsToStart.length) {
          shardsToStart.add(shardsToStart.length);
        }
        
        shardLauncher = Timer.periodic(Duration(milliseconds: 5200), (timer) {
          for(int i = 0; i < maxConcurrency; i++) {
            if (shardsToStart.isNotEmpty) {
              startShard(shardsToStart[0], _gatewayURL);
              shardsToStart.removeAt(0);
            }
          }
        });
    }

    Future<AuthenticationResponse> getBotGateway(int version) async {
        Response response = await http.get(url: "/v$version/gateway/bot");
        return AuthenticationResponse.fromResponse(response);
    }

    Future<void> startShard(int id, String gatewayURL) async {
        Console.info(message: "Starting shard #$id");

        final Shard shard = Shard(this, id, gatewayURL, _token);
        shards.putIfAbsent(id, () => shard);
    }
}