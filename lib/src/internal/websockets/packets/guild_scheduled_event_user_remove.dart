import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildScheduledEventUserRemove with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;
    final Snowflake eventId = payload['guild_scheduled_event_id'];

    final Guild? guild = payload['guild_id'] != null
        ? client.guilds.cache.get(payload['guild_id'])
        : client.guilds.cache.values.firstWhere((g) => g.scheduledEvents.cache.containsKey(eventId));

    final User? user = client.users.cache.get(payload['user_id']);

    if(guild != null && user != null) {
      final GuildMember? member = payload['guild_id'] != null ? guild.members.cache.get(user.id) : null;
      GuildScheduledEvent event = guild.scheduledEvents.cache.get(eventId)!;

      eventService.controller.add(GuildScheduledEventUserRemoveEvent(event, user, member));
    }
  }
}
