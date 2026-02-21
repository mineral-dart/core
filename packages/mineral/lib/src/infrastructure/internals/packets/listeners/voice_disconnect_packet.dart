import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class VoiceDisconnectPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.voiceStateUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (message.payload['channel_id'] == null) {
      final cacheKey = _marshaller.cacheKey.voiceState(
        message.payload['guild_id'],
        message.payload['user_id'],
      );

      final beforeRaw = await _marshaller.cache?.get(cacheKey);
      final before = beforeRaw != null
          ? await _marshaller.serializers.voice.serialize(beforeRaw)
          : null;

      await _marshaller.cache?.remove(cacheKey);

      if (before != null) {
        dispatch(event: Event.voiceDisconnect, params: [before]);
      }
    }
  }
}
