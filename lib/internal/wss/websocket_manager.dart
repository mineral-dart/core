import 'package:mineral/internal/either.dart';
import 'package:mineral/internal/services/http/discord_http_client.dart';
import 'package:mineral/internal/wss/shard.dart';
import 'package:mineral/services/http/http_response.dart';

final class WebsocketManager {
  final DiscordHttpClient http;
  final Map<int, Shard> shards = {};
  int totalShards = 0;

  WebsocketManager(this.http);

  Future<String> _getGateway () async {
    final result = await Either.future<HttpResponse, dynamic>(
      future: http.get('/gateway').build(),
    );

    return result is Success<HttpResponse>
      ? result.value.payload['url']
      : throw Exception('Failed gateway response');
  }

  Future _getBotGateway () async {
    final response = await http.get('/gateway/bot').build();

    return switch(response) {
      Success<HttpResponse>(value: final v) => v.payload,
      Failure() => switch (response.payload?.statusCode) {
        401 => throw Exception('Your token is invalid'),
        _ => throw Exception('Uncategorized error')
      },
      _ => throw Exception()
    };
  }

  Future<void> start ({ required int? shardCount }) async {
    final { 'url': url } = await _getBotGateway();
    print(url);

    // shardCount != null
    //   ? totalShards = shardCount
    //   : totalShards = response.shards
  }
}