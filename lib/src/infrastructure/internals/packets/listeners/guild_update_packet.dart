import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final serverCacheKey = _marshaller.cacheKey.server(message.payload['id']);
    final rawServer = await _marshaller.cache?.get(serverCacheKey);
    final before = rawServer != null
        ? await _marshaller.serializers.server.serialize(rawServer)
        : null;

    final rawAfter = await _marshaller.serializers.server.normalize(
      message.payload,
    );
    final after = await _marshaller.serializers.server.serialize(
      rawAfter,
    );

    dispatch(event: Event.serverUpdate, params: [before, after]);
  }
}
