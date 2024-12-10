abstract interface class ShardingConfigContract {
  String get token;

  int get intent;

  bool get compress;

  int get version;

  String get encoding;

  int get largeThreshold;

  int? get shardCount;
}
