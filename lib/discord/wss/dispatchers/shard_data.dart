import 'package:mineral/discord/wss/dispatchers/shard_authentication.dart';
import 'package:mineral/discord/wss/shard_message.dart';

abstract interface class ShardData {
  void dispatch(ShardMessage message);
}

final class ShardDataImpl implements ShardData {
  final ShardAuthentication authentication;

  ShardDataImpl(this.authentication);

  @override
  void dispatch(ShardMessage message) {

    return switch (message.type) {
      'READY' => ready(message.payload),
      _ => print('Unknown dispatch event ! ${message.type}'),
    };
  }

  void ready(Map<String, dynamic> payload) {
    authentication.setupRequirements(payload);
  }
}
