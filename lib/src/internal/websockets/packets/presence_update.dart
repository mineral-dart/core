import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class PresenceUpdatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = container.use<EventManager>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    String userId = payload['user']['id'];

    GuildMember? beforeMember = guild?.members.cache.get(userId)?.clone();
    GuildMember? afterMember = guild?.members.cache.get(userId);

    afterMember?.user.status = Status.from(guild: guild!, payload: payload);

    eventManager.controller.add(PresenceUpdateEvent(beforeMember, afterMember));
  }
}
