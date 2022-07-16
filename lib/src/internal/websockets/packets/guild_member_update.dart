import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class GuildMemberUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.memberUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    if (guild != null) {
      GuildMember? before = guild.members.cache.get(payload['user']['id']);

      VoiceManager voice = before != null
          ? before.voice
          : VoiceManager(isMute: payload['mute'], isDeaf: payload['deaf'], isSelfMute: false, isSelfDeaf: false, hasVideo: false, hasStream: false, channel: null);

      User user = User.from(payload['user']);
      GuildMember after = GuildMember.from(
          user: user,
          roles: guild.roles,
          member: payload,
          guildId: guild.id,
          voice: voice
      );

      after.guild = guild;
      after.voice.member ??= after;
      //after.voice.member = after;
      //after.voice.channel = guild.channels.cache.get(after.voice.channelId);

      manager.emit(
        event: Events.memberUpdate,
        params: [before, after]
      );

      if (before?.roles.cache.length != after.roles.cache.length) {
        manager.emit(
          event: Events.memberRolesUpdate,
          params: [before, after]
        );
      }

      guild.members.cache.set(after.user.id, after);
    }
  }
}
