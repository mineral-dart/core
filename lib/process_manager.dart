import 'package:mineral/api/http/header.dart';
import 'package:mineral/api/http/http_client.dart';
import 'package:mineral/discord/wss/shard.dart';
import 'package:mineral/discord/wss/sharding_config.dart';

abstract interface class ProcessManager {
  Map<int, Shard> get shards;

  ShardingConfig get config;

  HttpClient get httpClient;
}

final class ProcessManagerImpl implements ProcessManager {
  @override
  final Map<int, Shard> shards = {};

  @override
  final ShardingConfig config;

  @override
  final HttpClient httpClient;

  ProcessManagerImpl({required this.httpClient, required this.config}) {
    httpClient.config.headers.addAll([
      HeaderImpl.authorization('Bot ${config.token}'),
    ]);
  }

  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await httpClient.get('/gateway/bot');
    return switch(response.statusCode) {
      200 => response.body,
      401 => throw Exception('This token is invalid or revocated !'),
      _ => throw Exception(response.body['message']),
    };
  }

  Future<void> createShards() async {
    final {'url': String endpoint, 'shards': int shardCount} = await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final shard = ShardImpl(shardName: 'shard #$i', url: endpoint, manager: this);
      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }
}
