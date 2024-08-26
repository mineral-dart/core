import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadMembersUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadMembersUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadMembersUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final thread = await marshaller.dataStore.channel.getThread(Snowflake(payload['id'])) as ThreadChannel;
    final membersAdded = payload['added_members'] ?? [];
    final membersRemovedIds = payload['removed_member_ids'] ?? [];

    for (final memberThread in membersAdded) {
      final member = await marshaller.dataStore.member.getMember(serverId: payload['guild_id'], memberId: Snowflake(memberThread['user_id']));
      thread.members.putIfAbsent(member.id, () => member);

      dispatch(event: Event.serverThreadMemberAdd, params: [thread, server, member]);
    }

    for (final memberId in membersRemovedIds) {
      final member = await marshaller.dataStore.member.getMember(serverId: payload['guild_id'], memberId: Snowflake(memberId));
      thread.members.remove(Snowflake(memberId));

      dispatch(event: Event.serverThreadMemberRemove, params: [thread, server, member]);
    }

    final serverRaw = await marshaller.serializers.server.deserialize(server);
    final serverKey = marshaller.cacheKey.server(server.id);

    marshaller.cache.put(serverKey, serverRaw);

    final parentChannel = server.channels.list[Snowflake(thread.channelId)] as ServerTextChannel;
    parentChannel.threads.add(thread);

    final parentChannelRaw = await marshaller.serializers.channels.deserialize(parentChannel);
    final parentChannelKey = marshaller.cacheKey.channel(parentChannel.id);

    marshaller.cache.put(parentChannelKey, parentChannelRaw);
  }
}
