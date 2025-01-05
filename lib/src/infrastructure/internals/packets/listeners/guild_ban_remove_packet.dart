import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildBanRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildBanRemove;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final user = await _dataStore.user.get(message.payload['user']['id'], false);

    if (user case User(:final id)) {
      final memberCacheKey = _marshaller.cacheKey.member(server.id.value, id.value);
      await _marshaller.cache?.remove(memberCacheKey);

      dispatch(event: Event.serverBanRemove, params: [server, user]);
    }
  }
}
