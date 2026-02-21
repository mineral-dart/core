import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class VoiceLeavePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.voiceStateUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final cacheKey = _marshaller.cacheKey.voiceState(
      message.payload['guild_id'],
      message.payload['user_id'],
    );
    final beforeRaw = await _marshaller.cache?.get(cacheKey);

    // Trigger VoiceLeaveEvent whenever a user leaves ANY channel (including moves and disconnects)
    if (beforeRaw != null &&
        beforeRaw['channel_id'] != null &&
        beforeRaw['channel_id'] != message.payload['channel_id']) {
      final before = await _marshaller.serializers.voice.serialize(beforeRaw);
      dispatch(event: Event.voiceLeave, params: [before]);

      _marshaller.cache?.remove(cacheKey);
    }
  }
}
