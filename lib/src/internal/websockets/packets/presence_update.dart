import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class PresenceUpdatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    String userId = payload['user']['id'];

    GuildMember? beforeMember = guild?.members.cache.get(userId)?.clone();
    GuildMember? afterMember = guild?.members.cache.get(userId);

    afterMember?.user.status = Status.from(guild: guild!, payload: payload);

    eventService.controller.add(PresenceUpdateEvent(beforeMember, afterMember));
  }
}
