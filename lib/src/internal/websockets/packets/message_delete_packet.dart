import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MessageDeletePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    TextBasedChannel? channel = guild?.channels.cache.get(payload['channel_id']);

    if (channel?.id == null) {
      return;
    }

    Message? message = channel!.messages.cache.get(payload['id']);

    channel.messages.cache.remove(payload['id']);
    eventService.controller.add(MessageDeleteEvent(message, guild));
  }
}
