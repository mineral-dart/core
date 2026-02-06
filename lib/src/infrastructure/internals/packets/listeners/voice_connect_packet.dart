import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/voice/voice_connection_manager.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class VoiceConnectPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.voiceStateUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final cacheKey = _marshaller.cacheKey.voiceState(
      message.payload['guild_id'],
      message.payload['user_id'],
    );
    final before = await _marshaller.cache?.get(cacheKey);

    final rawVoiceState = await _marshaller.serializers.voice.normalize(
      message.payload,
    );
    final voiceState = await _marshaller.serializers.voice.serialize(
      rawVoiceState,
    );

    // Notify the voice connection manager of session_id for bot voice connections
    final voiceManager = ioc.resolveOrNull<VoiceConnectionManager>();
    if (voiceManager != null && message.payload['session_id'] != null) {
      final channelId = message.payload['channel_id'] != null
          ? Snowflake.parse(message.payload['channel_id'])
          : null;

      voiceManager.handleVoiceStateUpdate(
        serverId: Snowflake.parse(message.payload['guild_id']),
        channelId: channelId,
        sessionId: message.payload['session_id'],
        userId: Snowflake.parse(message.payload['user_id']),
      );
    }

    if (before == null && message.payload['channel_id'] != null) {
      dispatch(event: Event.voiceConnect, params: [voiceState]);
    }
  }
}
