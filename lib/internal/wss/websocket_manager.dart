import 'package:mineral/services/http/entities/either.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/wss/shard.dart';

final class WebsocketManager {
  final DiscordHttpClient http;
  final Map<int, Shard> shards = {};
  int totalShards = 0;

  WebsocketManager(this.http);

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

    print(session);

    // shardCount != null
    //   ? totalShards = shardCount
    //   : totalShards = response.shards
  }
}