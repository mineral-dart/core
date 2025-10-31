import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class VoiceMovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.voiceStateUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final cacheKey = _marshaller.cacheKey.voiceState(
      message.payload['guild_id'],
      message.payload['user_id'],
    );
    final rawBefore = await _marshaller.cache?.get(cacheKey);

    final rawVoiceState = await _marshaller.serializers.voice.normalize(
      message.payload,
    );
    final voiceState = await _marshaller.serializers.voice.serialize(
      rawVoiceState,
    );

    if (rawBefore != null &&
        rawBefore['channel_id'] != null &&
        voiceState.channelId != null) {
      final before = await _marshaller.serializers.voice.serialize(rawBefore);
      dispatch(event: Event.voiceMove, params: [before, voiceState]);
    }

    dispatch(event: Event.voiceStateUpdate, params: [voiceState]);
  }
}
