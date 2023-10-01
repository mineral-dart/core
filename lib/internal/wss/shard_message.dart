import 'package:mineral/internal/wss/shard_action.dart';

final class ShardMessage {
  final ShardAction action;
  final dynamic data;

  ShardMessage({ required this.action, this.data });

  factory ShardMessage.of(Map<String, dynamic> payload) =>
    ShardMessage(
      action: payload['action'],
      data: payload['data']
    );
}