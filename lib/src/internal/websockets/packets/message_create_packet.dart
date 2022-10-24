import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/events/message_create_event.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageCreatePacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);

    if (channel == null) {
      return;
    }

    Message message = Message.from(channel: channel, payload: payload);
    channel.messages.cache.putIfAbsent(message.id, () => message);

    eventManager.controller.add(MessageCreateEvent(message));
  }
}
