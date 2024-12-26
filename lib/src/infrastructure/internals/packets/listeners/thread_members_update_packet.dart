import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/thread_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadMembersUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadMembersUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();
    final payload = message.payload;

    final server = await _dataStore.server.get(payload['guild_id'], false);
    final thread = await _dataStore.channel.getThread(Snowflake(payload['id'])) as ThreadChannel;
    final membersAdded = payload['added_members'] ?? [];
    final membersRemovedIds = payload['removed_member_ids'] ?? [];

    for (final memberThread in membersAdded) {
      final member =
          await _dataStore.member.get(payload['guild_id'], memberThread['user_id'], false);
      // thread.members.putIfAbsent(member.id, () => member);

      dispatch(event: Event.serverThreadMemberAdd, params: [thread, server, member]);
    }

    for (final memberId in membersRemovedIds) {
      final member = await _dataStore.member.get(payload['guild_id'], memberId, false);
      // thread.members.remove(Snowflake(memberId));

      dispatch(event: Event.serverThreadMemberRemove, params: [thread, server, member]);
    }

    final serverRaw = await _marshaller.serializers.server.deserialize(server);
    final serverKey = _marshaller.cacheKey.server(server.id.value);

    _marshaller.cache.put(serverKey, serverRaw);
  }
}
