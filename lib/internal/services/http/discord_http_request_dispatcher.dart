import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/internal/services/http/discord_http_bucket.dart';
import 'package:mineral/internal/services/http/rate_limit.dart';
import 'package:mineral/services/http/contracts/http_request_dispatcher_contract.dart';
import 'package:mineral/services/http/http_response.dart';

final class DiscordHttpRequestDispatcher implements HttpRequestDispatcherContract {
  static const _maxRateLimitWaits = 10;

  final Client _client;

  final Map<String, DiscordHttpBucket> _rateLimitBuckets = {};
  DiscordHttpBucket? _globalBucket;

  DiscordHttpRequestDispatcher(this._client);

  @override
  Future<EitherContract> process(BaseRequest request) async {
    final rateLimitId = _getRateLimitId(request);
    var requestBucket = _rateLimitBuckets[rateLimitId];

    final buckets = [
      if (requestBucket != null) requestBucket,
      if (_globalBucket != null) _globalBucket!,
    ];

    for (final bucket in buckets) {
      int waits = 0;

      while (waits < _maxRateLimitWaits && !bucket.isReady) {
        waits++;
        await bucket.wait();
      }
    }

    requestBucket?.addPendingRequest(request);

    final Response result;
    try {
      final streamedResponse = await _client.send(request);

      result = await Response.fromStream(streamedResponse);
    } finally {
      requestBucket?.removePendingRequest(request);
    }

    final response = HttpResponse.fromHttpResponse(result);

    if (response.statusCode != 429) {
      // We handle 429 responses below
      final newBucket =
          _rateLimitBuckets.values.firstWhereOrNull((bucket) => bucket.inBucket(response)) ??
              DiscordHttpBucket.fromResponse(response);

      if (newBucket != null) {
        newBucket.updateRateLimit(response);

        requestBucket = newBucket;
        _rateLimitBuckets[rateLimitId] = newBucket;
      }
    } else {
      final isGlobal = response.headers[RateLimit.xRateLimitGlobal.value] == 'true';
      var affectedBucket = isGlobal ? _globalBucket : requestBucket;

      if (affectedBucket == null) {
        if (isGlobal) {
          affectedBucket = DiscordHttpBucket.global(
            resetAfter: double.parse(response.headers[RateLimit.retryAfter.value]!),
          );
          _globalBucket = affectedBucket;
        } else {
          // Could occur in the case of a cloudflare ban
          throw StateError('Received rate limit response with invalid rate limit headers');
        }
      } else {
        affectedBucket.updateRateLimit(response);
      }
    }

    return switch (result) {
      Response(statusCode: final code) when _isInRange(100, 399, code) =>
        Either.success<HttpResponse>(response),
      Response(statusCode: final code) when _isInRange(400, 599, code) =>
        Either.failure(response.reasonPhrase, payload: response),
      _ => Either.failure(response.reasonPhrase, payload: response),
    };
  }

  static final _limitedIdPattern = RegExp(r'/(?!guilds|channels|webhooks)[^/]+/\d+');
  String _getRateLimitId(BaseRequest request) {
    final route = request.url.path;

    final rateLimitRoute = route.replaceAllMapped(
      _limitedIdPattern,
      (match) => '/${match.group(1)}/substituted_id',
    );

    return '${request.method} $rateLimitRoute';
  }

  bool _isInRange(int start, int end, int value) => value >= start && value <= end;
}
