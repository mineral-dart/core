import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/event.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class VoiceStateUpdatePacket implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager eventManager = ioc.singleton(Service.event);
    MineralClient client = ioc.singleton(Service.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['user_id']);

    if(guild == null || member == null) {
      return;
    }

    VoiceManager before = member.voice;
    VoiceManager after = VoiceManager.from(payload, guild.id);

    member.voice = after;
    eventManager.controller.add(VoiceStateUpdateEvent(before, after));

    //User move
    if (before.channel != null && after.channel != null && before.channel != after.channel) {
      eventManager.controller.add(VoiceLeaveEvent(member, before.channel!));
      eventManager.controller.add(VoiceJoinEvent(member, before.channel!, after.channel!));
      eventManager.controller.add(VoiceMoveEvent(member, before.channel!, after.channel!));
    }

    //User join
    if (before.channel == null && after.channel != null) {
      eventManager.controller.add(VoiceJoinEvent(member, before.channel, after.channel!));
    }

    //User leave
    if (before.channel != null && after.channel == null) {
      eventManager.controller.add(VoiceLeaveEvent(member, before.channel!));
    }

    //User mute
    if (!before.isMute && after.isMute) {
      eventManager.controller.add(GuildMemberMuteEvent(member));
    }

    //User unmute
    if (before.isMute && !after.isMute) {
      eventManager.controller.add(GuildMemberUnmuteEvent(member));
    }

    //User undeaf
    if (before.isDeaf && !after.isDeaf) {
      eventManager.controller.add(GuildMemberDeafEvent(member));
    }

    //User deaf
    if(!before.isDeaf && after.isDeaf) {
      eventManager.controller.add(GuildMemberUndeafEvent(member));
    }

    //User selfUnMute
    if(before.isSelfMute && !after.isSelfMute) {
      eventManager.controller.add(GuildMemberSelfUnmuteEvent(member));
    }

    //User selfMute
    if(!before.isSelfMute && after.isSelfMute) {
      eventManager.controller.add(GuildMemberSelfMuteEvent(member));
    }

    //User selfUnDeaf
    if(before.isSelfDeaf && !after.isSelfDeaf) {
      eventManager.controller.add(GuildMemberSelfUndeafEvent(member));
    }

    //User selfDeaf
    if(!before.isSelfDeaf && after.isSelfDeaf) {
      eventManager.controller.add(GuildMemberSelfDeafEvent(member));
    }
  }
}
