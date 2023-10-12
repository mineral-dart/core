import 'package:mineral/internal/wss/shard_action.dart';
import 'package:mineral/internal/wss/shard_message.dart';

final class ShardMessageBuilder {
  late ShardAction _action;
  final Map<String, dynamic> _fields = {};
  dynamic _data;

  ShardMessageBuilder setAction(ShardAction action) {
    _action = action;
    return this;
  }

  ShardMessageBuilder setData (dynamic payload) {
    _data = payload;
    return this;
  }

  ShardMessageBuilder append(String key, dynamic value) {
    _fields.putIfAbsent(key, () => value);
    return this;
  }

  ShardMessage build() => ShardMessage(
    action: _action,
    data: _fields.isEmpty ? _data : _fields
  );
}