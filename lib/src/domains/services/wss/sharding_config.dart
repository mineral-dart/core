import 'package:mineral/contracts.dart';

enum WsEncoder {
  json('json'),
  etf('etf');

  final String value;
  const WsEncoder(this.value);
}

abstract interface class ShardingConfigContract {
  String get token;

  int get intent;

  bool get compress;

  int get version;

  EncodingStrategy get encoding;

  int get largeThreshold;

  int? get shardCount;

  int get maxReconnectAttempts;

  Duration get maxReconnectDelay;
}
