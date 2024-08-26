import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadRaw = await marshaller.serializers.thread.normalize(payload);
    final thread = await marshaller.serializers.thread.serialize(threadRaw);

    server.threads.add(thread);

    final serverRaw = await marshaller.serializers.server.deserialize(server);
    final serverKey = marshaller.cacheKey.server(server.id);

    marshaller.cache.put(serverKey, serverRaw);

    final parentChannel = server.channels.list[Snowflake(thread.channelId)] as ServerTextChannel;
    parentChannel.threads.add(thread);

    final parentChannelRaw = await marshaller.serializers.channels.deserialize(parentChannel);
    final parentChannelKey = marshaller.cacheKey.channel(parentChannel.id);

    marshaller.cache.put(parentChannelKey, parentChannelRaw);

    thread
      ..server = server
      ..parentChannel = parentChannel;

    dispatch(event: Event.serverThreadCreate, params: [thread, server]);
  }
}
