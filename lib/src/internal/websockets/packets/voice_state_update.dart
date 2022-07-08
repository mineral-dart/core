import 'dart:convert';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/voice_manager.dart';
import 'package:mineral/src/internal/entities/event_manager.dart';
import 'package:mineral/src/internal/event_emitter.dart';
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
      VoiceManager after = VoiceManager.from(payload, voiceChannel);

      member.voice = after;

      //User move
      if(before.channel != null && after.channel != null && before.channel != after.channel) {
        print('USER MOVE');
        manager.emit(
            event: Events.voiceDisconnect,
            params: [member]
        );
        manager.emit(
            event: Events.voiceConnect,
            params: [member]
        );
      }

      //User connect
      if(before.channel == null && after.channel != null) {
        print('USER CONNECT');
        manager.emit(
            event: Events.voiceConnect,
            params: [member]
        );
      }

      //User leave
      if(before.channel != null && after.channel == null) {
        print('USER LEAVE');
        manager.emit(
          event: Events.voiceDisconnect,
          params: [member]
        );
      }

      //User muted
      if(!before.isMute && after.isMute) {
        print('USER MUTE');
        manager.emit(
            event: Events.memberMuted,
            params: [member]
        );
      }

      //User unmute
      if(before.isMute && !after.isMute) {
        print('USER UNMUTE');
        manager.emit(
            event: Events.memberUnMuted,
            params: [member]
        );
      }

      //User undeaf
      if(before.isDeaf && !after.isDeaf) {
        print('USER UNDEAF');
        manager.emit(
            event: Events.memberUnDeaf,
            params: [member]
        );
      }

      //User deaf
      if(!before.isDeaf && after.isDeaf) {
        print('USER DEAF');
        manager.emit(
            event: Events.memberDeaf,
            params: [member]
        );
      }

      //User selfUnMute
      if(before.isSelfMute && !after.isSelfMute) {
        print('USER UNSELFMUTE');
        manager.emit(
            event: Events.memberSelfUnMuted,
            params: [member]
        );
      }

      //User selfMute
      if(!before.isSelfMute && after.isSelfMute) {
        print('USER SELFMUTE');
        manager.emit(
            event: Events.memberSelfMuted,
            params: [member]
        );
      }

      //User selfUnDeaf
      if(before.isSelfDeaf && !after.isSelfDeaf) {
        print('USER UNSELFDEAF');
        manager.emit(
            event: Events.memberSelfUnDeaf,
            params: [member]
        );
      }

      //User selfDeaf
      if(!before.isSelfDeaf && after.isSelfDeaf) {
        print('USER SELFDEAF');
        manager.emit(
            event: Events.memberSelfDeaf,
            params: [member]
        );
      }
    }
  }
}
