import 'package:mineral/discord/wss/shard.dart';
import 'package:mineral/discord/wss/shard_message.dart';

abstract interface class ShardData {
  void dispatch(ShardMessage message);
}

final class ShardDataImpl implements ShardData {
  final Shard shard;

  ShardDataImpl(this.shard);

  @override
  void dispatch(ShardMessage message) {
    print(message.payload);
    return switch (message.type) {
      'READY' => ready(message.payload),
      _ => print('Unknown message type ! ${message.type}'),
    };
  }

  void ready(Map<String, dynamic> payload) {
    shard.authentication.setupRequirements(payload);
    // shard.manager.serializer.serialize('READY', payload);
  }
}
