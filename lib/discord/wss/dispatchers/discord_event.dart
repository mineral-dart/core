import 'package:mineral/discord/wss/dispatchers/discord_authentication.dart';
import 'package:mineral/discord/wss/discord_payload_message.dart';

abstract interface class DiscordEvent {
  void dispatch(DiscordPayloadMessage message);
}

final class DiscordEventImpl implements DiscordEvent {
  final DiscordAuthentication authentication;

  DiscordEventImpl(this.authentication);

  @override
  void dispatch(DiscordPayloadMessage message) {

    return switch (message.type) {
      'READY' => ready(message.payload),
      _ => print('Unknown dispatch event ! ${message.type}'),
    };
  }

  void ready(Map<String, dynamic> payload) {
    authentication.setupRequirements(payload);
  }
}
