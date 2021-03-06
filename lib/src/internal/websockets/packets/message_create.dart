import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageCreate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.messageCreate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);

    if (channel == null) {
      return;
    }

    Message message = Message.from(channel: channel, payload: payload);
    channel.messages.cache.putIfAbsent(message.id, () => message);

    manager.emit(
      event: Events.messageCreate,
      params: [message]
    );
  }
}
