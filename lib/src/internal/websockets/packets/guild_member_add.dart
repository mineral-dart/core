import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildMemberAdd implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberAdd;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);

    if(guild != null) {
      User user = User.from(payload['user']);
      GuildMember member = GuildMember.from(
        user: user,
        roles: guild.roles,
        member: payload,
        guildId: guild.id,
        voice: VoiceManager(isMute: payload['mute'], isDeaf: payload['deaf'], isSelfMute: false, isSelfDeaf: false, hasVideo: false, hasStream: false, channel: null)
      );
      member.guild = guild;

      guild.members.cache.putIfAbsent(member.user.id, () => member);
      manager.emit(event: Events.memberJoin, params: [member]);
    }
  }
}
