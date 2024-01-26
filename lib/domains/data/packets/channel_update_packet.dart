import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelUpdatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final channel = marshaller.serializers.channels.serialize(message.payload);

    switch (channel) {
      case ServerChannel():
        registerServerChannel(message, channel, dispatch);
    }
  }

  void registerServerChannel(ShardMessage message, ServerChannel after, DispatchEvent dispatch) {
    final server = marshaller.storage.servers[message.payload['guild_id']];
    final before = marshaller.storage.channels[after.id];

    if (server != null) {
      after.server = server;
      server.channels.list[after.id] = after;
    }

    dispatch(event: MineralEvent.serverChannelUpdate, params: [before, after]);

    marshaller.storage.channels[after.id] = after;
  }
}
