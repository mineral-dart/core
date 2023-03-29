import 'package:mineral/core/api.dart';
import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/internal.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/events/guild_delete_event.dart';

class GuildRemovePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    Guild guild = client.guilds.cache.getOrFail(websocketResponse.payload['id']);

    eventService.controller.add(GuildDeleteEvent(guild));
    client.guilds.cache.remove(guild.id);
  }

}