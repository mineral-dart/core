abstract interface class ShardingConfig {
  String get token;

  int get intent;

  bool get compress;

  int get version;

  String get encoding;

  int get largeThreshold;

  int get shardCount;
}

final class ShardingConfigImpl implements ShardingConfig {
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
  final int shardCount;

  ShardingConfigImpl({
    required this.token,
    required this.intent,
    required this.version,
    this.compress = false,
    this.encoding = 'json',
    this.largeThreshold = 50,
    this.shardCount = 1,
  });
}
