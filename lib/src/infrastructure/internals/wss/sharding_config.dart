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
  final String encoding;

  @override
  final int largeThreshold;

  @override
  final int? shardCount;

  ShardingConfig({
    required this.token,
    required this.intent,
    required this.version,
    this.shardCount,
    this.compress = false,
    this.encoding = 'json',
    this.largeThreshold = 50,
  });
}
