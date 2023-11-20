import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/wss/constants/shard_disconnect_error.dart';
import 'package:mineral/discord/wss/sharding_config.dart';
import 'package:mineral/discord/wss/dispatchers/shard_authentication.dart';

abstract interface class ShardNetworkError {
  void dispatch(dynamic payload);
}

final class ShardNetworkErrorImpl implements ShardNetworkError {
  final WebsocketClient client;
  final ShardAuthentication authentication;
  final ShardingConfig config;

  ShardNetworkErrorImpl(this.client, this.authentication, this.config);

  @override
  void dispatch(dynamic payload) {
    final ShardDisconnectError? error = ShardDisconnectError.values
        .where((element) => element.code == payload as int)
        .firstOrNull;

    if (error case ShardDisconnectError(canBeReconnected: final canBeReconnected)) {
      print('${error.code} ${error.message}');
      return canBeReconnected ? authentication.resume() : authentication.reconnect();
    }

    print('Unknown error ! $payload');
  }
}
