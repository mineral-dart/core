import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MemberJoinPacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild guild = client.guilds.cache.getOrFail(payload['guild_id']);

    User user = User.from(payload['user']);
    GuildMember member = GuildMember.from(
      user: user,
      roles: guild.roles,
      member: payload,
      guild: guild,
      voice: VoiceManager.empty(payload['deaf'], payload['mute'], user.id, guild.id)
    );

    guild.members.cache.putIfAbsent(member.user.id, () => member);
    eventManager.controller.add(MemberJoinEvent(member));
  }
}
