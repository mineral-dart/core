import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/shard_message.dart';

abstract interface class ShardData {
  void dispatch(ShardMessage message);
}

final class ShardDataImpl implements ShardData {
  final Shard _shard;

  ShardDataImpl(this._shard);

  @override
  void dispatch(ShardMessage message) {
    if (message.type == 'READY') {
      _shard.authentication.setupRequirements(message.payload);
    }

    _shard.kernel.dataListener.packets.dispatch(message);
  }
}
