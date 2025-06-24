import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class VoiceStateSerializer implements SerializerContract<VoiceState> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'server_id': json['guild_id'],
      'channel_id': json['channel_id'],
      'user_id': json['user_id'],
      'session_id': json['session_id'],
      'deaf': json['deaf'],
      'mute': json['mute'],
      'self_deaf': json['self_deaf'],
      'self_mute': json['self_mute'],
      'self_video': json['self_video'],
      'suppress': json['suppress'],
      'request_to_speak_timestamp': json['request_to_speak_timestamp'],
      'discoverable': json['discoverable'],
    };

    final cacheKey =
        _marshaller.cacheKey.voiceState(json['guild_id'], json['user_id']);
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<VoiceState> serialize(Map<String, dynamic> json) async {
    return VoiceState(
        serverId: Snowflake.parse(json['server_id']),
        channelId: Snowflake.nullable(json['channel_id']),
        userId: Snowflake.parse(json['user_id']),
        sessionId: json['session_id'],
        isDeaf: json['deaf'],
        isMute: json['mute'],
        isSelfDeaf: json['self_deaf'],
        isSelfMute: json['self_mute'],
        hasSelfVideo: json['self_video'],
        isSuppress: json['suppress'],
        requestToSpeakTimestamp: json['request_to_speak_timestamp'] != null
            ? DateTime.parse(json['request_to_speak_timestamp'])
            : null,
        isDiscoverable: json['discoverable']);
  }

  @override
  Map<String, dynamic> deserialize(VoiceState state) {
    return {
      'server_id': state.serverId.value,
      'channel_id': state.channelId?.value,
      'user_id': state.userId.value,
      'session_id': state.sessionId,
      'deaf': state.isDeaf,
      'mute': state.isMute,
      'self_deaf': state.isSelfDeaf,
      'self_mute': state.isSelfMute,
      'self_stream': state.hasSelfVideo,
      'suppress': state.isSuppress,
      'request_to_speak_timestamp':
          state.requestToSpeakTimestamp?.toIso8601String(),
      'discoverable': state.isDiscoverable,
    };
  }
}
