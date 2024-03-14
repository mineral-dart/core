import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
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

  Future<void> registerServerChannel(String guildId, ServerChannel channel, DispatchEvent dispatch) async {
    final rawServer = await marshaller.cache.get(guildId);
    final server = await marshaller.serializers.server.serialize(rawServer);

    channel.server = server;
    marshaller.cache.remove(channel.id);

    dispatch(event: MineralEvent.serverChannelDelete, params: [channel]);

    server.channels.list.remove(channel.id);
    marshaller.cache.put(guildId, marshaller.serializers.server.deserialize(server));
  }
}
