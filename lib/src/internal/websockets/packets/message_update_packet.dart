import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageUpdatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle (WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    if (payload['author'] == null) {
      return;
    }

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);
    Message? before = channel?.messages.cache.get(payload['id']);

    if (channel != null) {
      Message after = Message.from(channel: channel, payload: payload);

      eventService.controller.add(MessageUpdateEvent(before, after));
      channel.messages.cache.set(after.id, after);
    }
  }
}
