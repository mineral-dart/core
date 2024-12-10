import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
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
    final payload = message.payload;

    final server = await _dataStore.server.getServer(payload['guild_id']);
    final thread = await _dataStore.channel.getThread(Snowflake(payload['id']))
        as ThreadChannel;
    final membersAdded = payload['added_members'] ?? [];
    final membersRemovedIds = payload['removed_member_ids'] ?? [];

    for (final memberThread in membersAdded) {
      final member = await _dataStore.member.getMember(
          serverId: payload['guild_id'],
          memberId: Snowflake(memberThread['user_id']));
      thread.members.putIfAbsent(member.id, () => member);

      dispatch(
          event: Event.serverThreadMemberAdd, params: [thread, server, member]);
    }

    for (final memberId in membersRemovedIds) {
      final member = await _dataStore.member.getMember(
          serverId: payload['guild_id'], memberId: Snowflake(memberId));
      thread.members.remove(Snowflake(memberId));

      dispatch(
          event: Event.serverThreadMemberRemove,
          params: [thread, server, member]);
    }

    final serverRaw = await _marshaller.serializers.server.deserialize(server);
    final serverKey = _marshaller.cacheKey.server(server.id);

    _marshaller.cache.put(serverKey, serverRaw);

    final parentChannel =
        server.channels.list[Snowflake(thread.channelId)] as ServerTextChannel;
    parentChannel.threads.add(thread);

    final parentChannelRaw =
        await _marshaller.serializers.channels.deserialize(parentChannel);
    final parentChannelKey = _marshaller.cacheKey.channel(parentChannel.id);

    _marshaller.cache.put(parentChannelKey, parentChannelRaw);
  }
}
