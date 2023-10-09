import 'package:http/http.dart' as http;
import 'package:mineral/internal/services/http/rate_limit.dart';

final class DiscordHttpBucket {
  final List<http.BaseRequest> _pendingRequests = [];
  final String bucketId;

  /// The number of requests currently pending in this bucket.
  int get pendingRequests => _pendingRequests.length;

  int _remaining;
  DateTime _resetAt;

  /// The number of requests remaining in this bucket.
  int get remaining => _remaining;

  /// The time at which this bucket resets.
  DateTime get resetAt => _resetAt;

  /// The duration after which this bucket will reset.
  Duration get resetAfter => DateTime.now().difference(resetAt);

  /// Whether this bucket is ready to sent a new request.
  bool get isReady => remaining - pendingRequests > 0;

  DiscordHttpBucket._({
    required this.bucketId,
    required int remaining,
    required double resetAfter,
  })  : _resetAt = _resetAtFromAfter(resetAfter),
        _remaining = remaining;

  factory DiscordHttpBucket.global({required double resetAfter}) => DiscordHttpBucket._(
        bucketId: '__GLOBAL__',
        remaining: 1, // Requests are never counted against the global limit
        resetAfter: resetAfter,
      );

  void addPendingRequest(http.BaseRequest request) {
    _pendingRequests.add(request);
  }

  void removePendingRequest(http.BaseRequest request) {
    _pendingRequests.remove(request);
  }

  /// Return a future that completes once this bucket may be ready to send a new request.
  ///
  /// If many requests are waiting on this bucket, requests might still need to wait longer before
  /// being sent. Check [isReady] to see if the request can be sent.
  Future<void> wait() => resetAfter.isNegative
      ? Future.delayed(const Duration(milliseconds: 50))
      : Future.delayed(resetAfter);

  void updateRateLimit(http.Response response) {
    if (!inBucket(response)) {
      return;
    }

    _remaining = _getHeader<int>(RateLimit.xRateLimitRemaining, response.headers) ?? _remaining;

    final resetAfter = _getHeader<double>(RateLimit.xRateLimitResetAfter, response.headers) ??
        _getHeader<double>(RateLimit.retryAfter, response.headers);
    if (resetAfter != null) {
      _resetAt = _resetAtFromAfter(resetAfter);
    }
  }

  bool inBucket(http.Response response) =>
      _getHeader(RateLimit.xRateLimitBucket, response.headers) != null;

  static T? _getHeader<T>(RateLimit rateLimit, Map<String, String> headers) {
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

  static DateTime _resetAtFromAfter(double resetAfter) => DateTime.now().add(
        Duration(microseconds: (resetAfter * Duration.microsecondsPerSecond).ceil()),
      );

  static DiscordHttpBucket? fromResponse(http.Response response) {
    final bucketId = _getHeader<String>(RateLimit.xRateLimitBucket, response.headers);
    final remaining = _getHeader<int>(RateLimit.xRateLimitRemaining, response.headers);
    final reset = _getHeader<double>(RateLimit.xRateLimitReset, response.headers);
    final resetAfter = _getHeader<double>(RateLimit.xRateLimitResetAfter, response.headers);
    final limit = _getHeader<int>(RateLimit.xRateLimitLimit, response.headers);

    if ([bucketId, remaining, reset, resetAfter, limit].contains(null)) {
      return null;
    }

    return DiscordHttpBucket._(
      bucketId: bucketId!,
      remaining: remaining!,
      resetAfter: resetAfter!,
    );
  }
}
