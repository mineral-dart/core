import 'package:mineral/domains/wss/constants/shard_disconnect_error.dart';
import 'package:mineral/domains/wss/shard.dart';

abstract interface class ShardNetworkError {
  void dispatch(dynamic payload);
}

final class ShardNetworkErrorImpl implements ShardNetworkError {
  final Shard shard;

  ShardNetworkErrorImpl(this.shard);

  @override
  void dispatch(dynamic payload) {
    print(payload);
    final ShardDisconnectError? error = ShardDisconnectError.values
        .where((element) => element.code == payload as int)
        .firstOrNull;

    if (error case ShardDisconnectError(canBeReconnected: final canBeReconnected)) {
      print('${error.code} ${error.message}');
      if (error.code == 4005) {
        return;
      }
      return canBeReconnected ? shard.authentication.resume() : shard.authentication.reconnect();
    }

    print('Unknown error ! $payload');
  }
}
