import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildEmojisUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildEmojisUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final serverCacheKey = _marshaller.cacheKey.server(server.id.value);

    final emojis = await List.from(message.payload['emojis']).map((element) async {
      final raw = await _marshaller.serializers.emojis.normalize({
        ...element,
        'guild_id': server.id.value,
      });
      return _marshaller.serializers.emojis.serialize(raw);
    }).wait;

    final rawServer = await _marshaller.serializers.server.deserialize(server);
    await _marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(
        event: Event.serverEmojisUpdate,
        params: [emojis.asMap().map((_, element) => MapEntry(element.id, element)), server]);
  }
}
