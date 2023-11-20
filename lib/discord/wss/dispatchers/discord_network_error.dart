import 'package:mineral/api/wss/websocket_client.dart';
import 'package:mineral/discord/wss/constants/discord_disconnect_error.dart';
import 'package:mineral/discord/wss/discord_websocket_config.dart';
import 'package:mineral/discord/wss/dispatchers/discord_authentication.dart';

abstract interface class DiscordNetworkError {
  void dispatch(dynamic payload);
}

final class DiscordNetworkErrorImpl implements DiscordNetworkError {
  final WebsocketClient client;
  final DiscordAuthentication authentication;
  final DiscordWebsocketConfig config;

  DiscordNetworkErrorImpl(this.client, this.authentication, this.config);

  @override
  void dispatch(dynamic payload) {
    final DiscordDisconnectError? error = DiscordDisconnectError.values
        .where((element) => element.code == payload as int)
        .firstOrNull;

    if (error case DiscordDisconnectError(canBeReconnected: final canBeReconnected)) {
      print('${error.code} ${error.message}');
      return canBeReconnected ? authentication.resume() : authentication.reconnect();
    }

    print('Unknown error ! $payload');
  }
}
