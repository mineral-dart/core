import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral/src/internal/services/command_service.dart';
import 'package:mineral/src/internal/services/context_menu_service.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildCreatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    CommandService commandManager = container.use<CommandService>();
    ContextMenuService contextMenuService = container.use<ContextMenuService>();
    MineralClient client = container.use<MineralClient>();

    websocketResponse.payload['guild_id'] = websocketResponse.payload['id'];
    final Guild guild = await client.makeGuild(client, websocketResponse.payload);

    final commands = commandManager.getGuildCommands(guild);
    final contextMenus = contextMenuService.getFromGuild(guild);
    if (commands.isNotEmpty || contextMenus.isNotEmpty) {
      await client.registerGuildCommands(
        guild: guild,
        commands: commands,
        contextMenus: contextMenus,
      );
    }

    eventService.controller.add(GuildCreateEvent(guild));
  }
}
