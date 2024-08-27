import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server =
        await marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadCacheKey = marshaller.cacheKey.thread(payload['id']);

    final beforeRaw = await marshaller.cache.getOrFail(threadCacheKey);
    final before = await marshaller.serializers.thread.serialize(beforeRaw);

    final afterRaw = await marshaller.serializers.thread.normalize(payload);
    final after = await marshaller.serializers.thread.serialize(afterRaw);

    server.threads.add(after);

    final serverRaw = await marshaller.serializers.server.deserialize(server);
    final serverKey = marshaller.cacheKey.server(server.id);

    marshaller.cache.put(serverKey, serverRaw);

    after
      ..server = server
      ..parentChannel =
          server.channels.list[Snowflake(after.channelId)] as ServerTextChannel;

    before
      ..server = server
      ..parentChannel = server.channels.list[Snowflake(before.channelId)]
          as ServerTextChannel;

    dispatch(event: Event.serverThreadUpdate, params: [before, after, server]);
  }
}
