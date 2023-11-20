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
    return switch (message.type) {
      'READY' => ready(message.payload),
      _ => shard.manager.serializer.serialize(message.type!, message.payload)
    };
  }

  void ready(Map<String, dynamic> payload) {
    shard.authentication.setupRequirements(payload);
    shard.manager.serializer.serialize('READY', payload);
  }
}
