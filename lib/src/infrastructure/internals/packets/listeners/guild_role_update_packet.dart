import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildRoleUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final serverCacheKey =
        _marshaller.cacheKey.server(message.payload['guild_id']);
    final server =
        await _dataStore.server.get(message.payload['guild_id'], false);

    final roleCacheKey = _marshaller.cacheKey
        .serverRole(server.id.value, message.payload['role']['id']);
    final rawBefore = await _marshaller.cache?.get(roleCacheKey);
    final before = rawBefore != null
        ? _marshaller.serializers.role.serialize(rawBefore)
        : null;

    final rawRole = await _marshaller.serializers.role.normalize({
      'guild_id': server.id,
      ...message.payload['role'],
    });
    final role = await _marshaller.serializers.role.serialize(rawRole);

    final rawServer = await _marshaller.serializers.server.deserialize(server);
    await _marshaller.cache?.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverRoleUpdate, params: [before, role, server]);
  }
}
