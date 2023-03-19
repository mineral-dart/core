import 'package:mineral/core/api.dart';
import 'package:mineral/core/events.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/mixins/container.dart';
import 'package:mineral/src/internal/services/event_service.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class VoiceStateUpdatePacket with Container implements WebsocketPacket {
  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventService eventService = container.use<EventService>();
    MineralClient client = container.use<MineralClient>();

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['user_id']);

    if(guild == null || member == null) {
      return;
    }

    VoiceManager before = member.voice;
    VoiceManager after = VoiceManager.from(payload, guild.id);

    member.voice = after;
    eventService.controller.add(VoiceStateUpdateEvent(before, after));

    //User move
    if (before.channel != null && after.channel != null && before.channel != after.channel) {
      eventService.controller.add(VoiceLeaveEvent(member, before.channel!));
      eventService.controller.add(VoiceJoinEvent(member, before.channel!, after.channel!));
      eventService.controller.add(VoiceMoveEvent(member, before.channel!, after.channel!));
    }

    //User join
    if (before.channel == null && after.channel != null) {
      eventService.controller.add(VoiceJoinEvent(member, before.channel, after.channel!));
    }

    //User leave
    if (before.channel != null && after.channel == null) {
      eventService.controller.add(VoiceLeaveEvent(member, before.channel!));
    }

    //User mute
    if (!before.isMute && after.isMute) {
      eventService.controller.add(MemberMuteEvent(member));
    }

    //User unmute
    if (before.isMute && !after.isMute) {
      eventService.controller.add(MemberUnmuteEvent(member));
    }

    //User undeaf
    if (before.isDeaf && !after.isDeaf) {
      eventService.controller.add(MemberDeafEvent(member));
    }

    //User deaf
    if(!before.isDeaf && after.isDeaf) {
      eventService.controller.add(MemberUndeafEvent(member));
    }

    //User selfUnMute
    if(before.isSelfMute && !after.isSelfMute) {
      eventService.controller.add(MemberSelfUnmuteEvent(member));
    }

    //User selfMute
    if(!before.isSelfMute && after.isSelfMute) {
      eventService.controller.add(MemberSelfMuteEvent(member));
    }

    //User selfUnDeaf
    if(before.isSelfDeaf && !after.isSelfDeaf) {
      eventService.controller.add(MemberSelfUndeafEvent(member));
    }

    //User selfDeaf
    if(!before.isSelfDeaf && after.isSelfDeaf) {
      eventService.controller.add(MemberSelfDeafEvent(member));
    }
  }
}
