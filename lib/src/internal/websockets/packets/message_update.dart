import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.messageUpdate;

  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);
    Message? before = channel?.messages.cache.get(payload['id']);

    if (channel != null) {
      Message after = Message.from(channel: channel, payload: payload);
      manager.emit(
        event: Events.messageUpdate,
        params: [before, after]
      );

      channel.messages.cache.set(after.id, after);
    }
  }
}
