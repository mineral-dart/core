import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildMemberChunkPacker with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    MineralClient client = container.use<MineralClient>();
    dynamic payload = websocketResponse.payload;

    if (payload['guild_id'] == null) {
      return;
    }

    Guild? guild = client.guilds.cache.getOrFail(payload['guild_id']);

    for (dynamic member in payload['members']) {
      if(guild.members.cache.containsKey(member['user']['id'])) {
        continue;
      }

      User user = User.from(member['user']);
      GuildMember guildMember = GuildMember.from(
          roles: guild.roles,
          user: user,
          member: member,
          guild: guild,
          voice: VoiceManager.empty(member['deaf'], member['mute'], user.id, payload['guild_id'])
      );

      guild.members.cache.putIfAbsent(guildMember.user.id, () => guildMember);
      client.users.cache.putIfAbsent(user.id, () => user);
    }
  }
}
