import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class MemberUpdatePacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      GuildMember? before = guild.members.cache.get(payload['user']['id']);

      VoiceManager voice = before != null
        ? before.voice
        : VoiceManager.empty(payload['deaf'], payload['mute'], payload['user']['id'], guild.id);

      User user = User.from(payload['user']);
      GuildMember after = GuildMember.from(
        user: user,
        roles: guild.roles,
        member: payload,
        guild: guild,
        voice: voice
      );

      eventManager.controller.add(MemberUpdateEvent(before!, after));

      if (before.roles.cache.length != after.roles.cache.length) {
        eventManager.controller.add(MemberRoleUpdateEvent(before, after));
      }

      guild.members.cache.set(after.user.id, after);
    }
  }
}
