import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:mineral/internal/services/http/discord_http_bucket.dart';
import 'package:mineral/internal/services/http/rate_limit.dart';
import 'package:mineral/services/http/contracts/http_request_dispatcher_contract.dart';
import 'package:mineral/services/http/contracts/http_response.dart';
import 'package:mineral/services/http/entities/http_error.dart';
import 'package:mineral/services/http/entities/http_payload.dart';

final class DiscordHttpRequestDispatcher implements HttpRequestDispatcherContract {
  static const _maxRateLimitWaits = 10;

  final Client _client;

  final Map<String, DiscordHttpBucket> _rateLimitBuckets = {};
  DiscordHttpBucket? _globalBucket;

  DiscordHttpRequestDispatcher(this._client);

  @override
  Future<HttpResponse> process(BaseRequest request) async {
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

    if (result.statusCode != 429) {
      // We handle 429 responses below
      final newBucket =
          _rateLimitBuckets.values.firstWhereOrNull((bucket) => bucket.inBucket(result)) ??
              DiscordHttpBucket.fromResponse(result);

      if (newBucket != null) {
        newBucket.updateRateLimit(result);

        requestBucket = newBucket;
        _rateLimitBuckets[rateLimitId] = newBucket;
      }
    } else {
      final isGlobal = result.headers[RateLimit.xRateLimitGlobal.value] == 'true';
      var affectedBucket = isGlobal ? _globalBucket : requestBucket;

      if (affectedBucket == null) {
        if (isGlobal) {
          affectedBucket = DiscordHttpBucket.global(
            resetAfter: double.parse(result.headers[RateLimit.retryAfter.value]!),
          );
          _globalBucket = affectedBucket;
        } else {
          // Could occur in the case of a cloudflare ban
          throw StateError('Received rate limit response with invalid rate limit headers');
        }
      } else {
        affectedBucket.updateRateLimit(result);
      }
    }
    return switch (result) {
      Response(statusCode: final code) when _isInRange(100, 399, code) => HttpPayload.fromHttpResponse(result),
      Response(statusCode: final code) when _isInRange(400, 599, code) => HttpError.fromHttpResponse(result),
      _ => HttpError.fromHttpResponse(result),
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
