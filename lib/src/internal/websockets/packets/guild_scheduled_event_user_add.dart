import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildScheduledEventUserAdd implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;
    final Snowflake eventId = payload['guild_scheduled_event_id'];

    final Guild? guild = payload['guild_id'] != null
      ? client.guilds.cache.get(payload['guild_id'])
      : client.guilds.cache.values.firstWhere((g) => g.scheduledEvents.cache.containsKey(eventId));

    final User? user = client.users.cache.get(payload['user_id']);

    if(guild != null && user != null) {
      final GuildMember? member = payload['guild_id'] != null ? guild.members.cache.get(user.id) : null;

      GuildScheduledEvent event = guild.scheduledEvents.cache.get(eventId)!;

      eventManager.controller.add(GuildScheduledEventUserAddEvent(event, user, member));
    }
  }
}
