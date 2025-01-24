import 'package:mineral/contracts.dart';

final class ShardingConfig implements ShardingConfigContract {
  @override
  final String token;

  @override
  final int intent;

  @override
  final bool compress;

  @override
  final int version;

  @override
  final EncodingStrategy encoding;

  @override
  final int largeThreshold;

  @override
  final int? shardCount;

  ShardingConfig({
    required this.token,
    required this.intent,
    required this.version,
    required this.encoding,
    this.shardCount,
    this.compress = false,
    this.largeThreshold = 50,
  });
}
