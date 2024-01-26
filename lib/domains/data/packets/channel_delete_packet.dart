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
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final channel = marshaller.serializers.channels.serialize(message.payload);

    switch (channel) {
      case ServerChannel():
        registerServerChannel(channel, dispatch);
    }
  }

  void registerServerChannel(ServerChannel channel, DispatchEvent dispatch) {
    dispatch(event: MineralEvent.serverChannelDelete, params: [channel]);
    marshaller.storage.channels.remove(channel.id);
  }
}
