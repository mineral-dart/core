import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildScheduledEventUpdate with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      GuildScheduledEvent? before = guild.scheduledEvents.cache.get(payload['id']);
      GuildScheduledEvent after = GuildScheduledEvent.from(channelManager: guild.channels, memberManager: guild.members, payload: payload);
      guild.scheduledEvents.cache.set(after.id, after);

      eventService.controller.add(GuildScheduledEventUpdateEvent(before, after));
    }
  }
}
