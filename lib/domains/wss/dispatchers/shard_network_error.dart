import 'package:mineral/application/logger/logger.dart';
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
    if (payload == null) {
      Logger.singleton().trace('Unknown error with empty exit code, restarting…');

      shard.client.disconnect();
      shard.client.connect();

      return;
    }

    final ShardDisconnectError? error = ShardDisconnectError.values
        .where((element) => element.code == payload)
        .firstOrNull;

    if (error case ShardDisconnectError(canBeReconnected: final canBeReconnected)) {
      return canBeReconnected ? shard.authentication.resume() : shard.authentication.reconnect();
    }

    if (error case int when error == 1005) {
      return shard.client.disconnect();
    }
  }
}
