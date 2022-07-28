import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/event_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_packet.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';

class VoiceStateUpdate implements WebsocketPacket {
  @override
  PacketType packetType = PacketType.voiceStateUpdate;

  @override
  Future<void> handle(WebsocketResponse websocketResponse) async {
    EventManager manager = ioc.singleton(ioc.services.event);
    MineralClient client = ioc.singleton(ioc.services.client);

    dynamic payload = websocketResponse.payload;

    Guild? guild = client.guilds.cache.get(payload['guild_id']);
    GuildMember? member = guild?.members.cache.get(payload['user_id']);
    VoiceChannel? voiceChannel = guild?.channels.cache.get(payload['channel_id']);
    if (guild != null && member != null) {
      VoiceManager before = member.voice;
      VoiceManager after = VoiceManager.from(payload, member, voiceChannel);

      member.voice = after;
      after.member = member;

      manager.emit(
        event: Events.voiceStateUpdate,
        params: [before, after]
      );

      //User move
      if(before.channel != null && after.channel != null && before.channel != after.channel) {
        _emitEvent(manager, Events.voiceDisconnect, [member, before.channel], before.channel!.id);
        _emitEvent(manager, Events.voiceConnect, [member, before.channel, after.channel], after.channel!.id);
      }

      //User connect
      if(before.channel == null && after.channel != null) {
        _emitEvent(manager, Events.voiceConnect, [member, before.channel, after.channel], after.channel!.id);
      }

      //User leave
      if(before.channel != null && after.channel == null) {
        _emitEvent(manager, Events.voiceDisconnect, [member, before.channel], before.channel!.id);
      }

      //User muted
      if(!before.isMute && after.isMute) {
        manager.emit(
            event: Events.memberMuted,
            params: [member]
        );
      }

      //User unmute
      if(before.isMute && !after.isMute) {
        manager.emit(
            event: Events.memberUnMuted,
            params: [member]
        );
      }

      //User undeaf
      if(before.isDeaf && !after.isDeaf) {
        manager.emit(
            event: Events.memberUnDeaf,
            params: [member]
        );
      }

      //User deaf
      if(!before.isDeaf && after.isDeaf) {
        manager.emit(
            event: Events.memberDeaf,
            params: [member]
        );
      }

      //User selfUnMute
      if(before.isSelfMute && !after.isSelfMute) {
        manager.emit(
            event: Events.memberSelfUnMuted,
            params: [member]
        );
      }

      //User selfMute
      if(!before.isSelfMute && after.isSelfMute) {
        manager.emit(
            event: Events.memberSelfMuted,
            params: [member]
        );
      }

      //User selfUnDeaf
      if(before.isSelfDeaf && !after.isSelfDeaf) {
        manager.emit(
            event: Events.memberSelfUnDeaf,
            params: [member]
        );
      }

      //User selfDeaf
      if(!before.isSelfDeaf && after.isSelfDeaf) {
        manager.emit(
            event: Events.memberSelfDeaf,
            params: [member]
        );
      }
    }
  }

  _emitEvent(EventManager manager, Events event, dynamic params, Snowflake customId) {
    manager.emit(
      event: event,
      params: params,
    );

    manager.emit(
      event: event,
      params: params,
      customId: customId
    );
  }
}
