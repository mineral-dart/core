import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ChannelDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serialize(message.payload);

    switch (channel) {
      case ServerChannel():
        await registerServerChannel(message.payload['guild_id'], channel, dispatch);
    }
  }

  Future<void> registerServerChannel(Snowflake guildId, ServerChannel channel, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(guildId);
    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final channelCacheKey = marshaller.cacheKey.channel(channel.id);

    channel.server = server;
    server.channels.list.remove(channel.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);
    await marshaller.cache.remove(channelCacheKey);

    dispatch(event: Event.serverChannelDelete, params: [channel]);
  }
}
