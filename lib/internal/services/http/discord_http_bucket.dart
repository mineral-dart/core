import 'package:http/http.dart' as http;
import 'package:mineral/internal/services/http/rate_limite.dart';
import 'package:mineral/services/http/http_response.dart';

final class DiscordHttpBucket {
  final List<http.BaseRequest> _pendingRequests = [];
  final String bucketId;

  double remaining;
  double reset;
  double resetAfter;

  DiscordHttpBucket._({
    required this.bucketId,
    required this.remaining,
    required this.reset,
    required this.resetAfter,
  });

  void addPendingRequest (http.BaseRequest request) {
    _pendingRequests.add(request);
  }

  void removePendingRequest (http.BaseRequest request) {
    _pendingRequests.remove(request);
  }

  void updateRateLimit(HttpResponse response) {
    if (!inBucket(response)) {
      return;
    }

    remaining = _getHeader<double>(RateLimit.xRateLimitRemaining, response.headers) ?? remaining;
    reset = _getHeader<double>(RateLimit.xRateLimitReset, response.headers) ?? reset;
    resetAfter = _getHeader<double>(RateLimit.xRateLimitResetAfter, response.headers) ?? resetAfter;
  }

  bool inBucket(HttpResponse response) => _getHeader(RateLimit.xRateLimitBucket, response.headers) != null;

  static T? _getHeader<T> (RateLimit rateLimit, Map<String, String> headers) {
    final value = headers[rateLimit.value];

    if (value == null) {
      return null;
    }

    return switch (T) {
      int => int.tryParse(value),
      double => double.tryParse(value),
      bool => bool.tryParse(value),
      _ => value
    } as T?;
  }

  static DiscordHttpBucket? fromResponse (HttpResponse response) {
    final bucketId = _getHeader<String>(RateLimit.xRateLimitBucket, response.headers);
    final remaining = _getHeader<double>(RateLimit.xRateLimitRemaining, response.headers);
    final reset = _getHeader<double>(RateLimit.xRateLimitReset, response.headers);
    final resetAfter = _getHeader<double>(RateLimit.xRateLimitResetAfter, response.headers);
    final limit = _getHeader<int>(RateLimit.xRateLimitLimit, response.headers);

    if ([bucketId, remaining, reset, resetAfter, limit].contains(null)) {
      return null;
    }

    return DiscordHttpBucket._(
      bucketId: bucketId!,
      remaining: remaining!,
      reset: reset!,
      resetAfter: resetAfter!
    );
  }
}