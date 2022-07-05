import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class PresenceUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.ready;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    String userId = payload['user']['id'];

    GuildMember? beforeMember = guild?.members.cache.get(userId)?.clone();
    GuildMember? afterMember = guild?.members.cache.get(userId);

    afterMember?.user.status = Status.from(guild: guild!, payload: payload);

    manager.emit(
      event: Events.presenceUpdate,
      params: [beforeMember, afterMember]
    );
  }
}
