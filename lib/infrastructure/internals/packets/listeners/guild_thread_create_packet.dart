import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildThreadCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildThreadCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  GuildThreadCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final thread = await marshaller.serializers.thread.serializeCache(payload);

    thread.server = server;
    thread.owner.member.server = server;

    final threadCacheKey = marshaller.cacheKey.threadChannel(serverId: server.id, threadId: thread.id);
    final threadRaw = await marshaller.serializers.channels.deserialize(thread);

    await marshaller.cache.put(threadCacheKey, threadRaw);

    dispatch(event: Event.serverThreadCreate, params: [thread, server]);
  }
}
