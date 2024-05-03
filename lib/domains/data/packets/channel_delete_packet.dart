import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

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

    channel.server = server;
    server.channels.list.remove(channel.id);

    await Future.wait([
      marshaller.cache.put(guildId, await marshaller.serializers.server.deserialize(server)),
      marshaller.cache.remove(channel.id)
    ]);

    dispatch(event: MineralEvent.serverChannelDelete, params: [channel]);
  }
}
