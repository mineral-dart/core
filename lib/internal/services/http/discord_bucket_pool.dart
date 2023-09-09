import 'package:collection/collection.dart';
import 'package:mineral/internal/services/http/discord_http_bucket.dart';
import 'package:mineral/services/http/http_response.dart';

final class DiscordBucketPool {
  final Map<String, DiscordHttpBucket> _buckets = {};

  String makePoolId (String method, String url) => '$method:$url';

  DiscordHttpBucket? getBucketFromPoolId (String bucketId) => _buckets[bucketId];

  DiscordHttpBucket? getBucketIfExists (HttpResponse response) =>
      _buckets.values.firstWhereOrNull((bucket) => bucket.inBucket(response));

  void updateBucket(String poolName, DiscordHttpBucket bucket) {
    final bucket = _buckets[poolName];
    if (bucket != null) {
      bucket.
    }
  }
}