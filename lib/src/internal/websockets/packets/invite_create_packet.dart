import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/invites/invite.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class InviteCreatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    MineralClient client = container.use<MineralClient>();
    EventService eventService = container.use<EventService>();

    final invite = Invite.from(websocketResponse.payload);

    final Guild guild = client.guilds.cache.getOrFail(invite.guild.id);
    guild.invites.cache.putIfAbsent(invite.code, () => invite);

    eventService.controller.add(InviteCreateEvent(invite));
  }
}
