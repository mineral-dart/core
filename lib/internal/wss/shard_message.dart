import 'package:mineral/internal/wss/shard_action.dart';

final class ShardMessage {
  final ShardAction action;
  final dynamic data;

  ShardMessage({ required this.action, this.data });
}