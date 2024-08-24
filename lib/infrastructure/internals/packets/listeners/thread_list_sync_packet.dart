import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadListSyncPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadListSync;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadListSyncPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadChannels = payload['threads'] as List<Map<String, dynamic>>;

    final threads = await threadChannels.map((element) async {
      final thread = await marshaller.serializers.thread.serializeRemote(element);

      thread.server = server;

      for (final member in thread.members) {
        member.member.server = server;
        member.member.roles.server = server;
      }

      //todo

      final threadCacheKey = marshaller.cacheKey.threadChannel(serverId: payload['id'], threadId: thread.id);
      final threadRaw = await marshaller.serializers.thread.deserialize(thread);

      await marshaller.cache.put(threadCacheKey, threadRaw);

      return thread;
    }).wait;

    dispatch(event: Event.serverThreadDelete, params: [threads, server]);
  }
}
