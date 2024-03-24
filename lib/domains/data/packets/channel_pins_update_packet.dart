import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/helper.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelPinsUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelPinsUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelPinsUpdatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    switch (message.payload['guild_id']) {
      case String():
        registerServerChannelPins(message, dispatch);
    }
  }

  Future<void> registerServerChannelPins(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final channel = await marshaller.dataStore.channel.getChannel(message.payload['channel_id']);

    final timestamps = Helper.createOrNull(
        field: message.payload['last_pin_timestamp'],
        fn: () => DateTime.tryParse(message.payload['last_pin_timestamp']));

    if (channel is ServerChannel) {
      channel.server = server;
    }

    if (channel case Channel()) {
      final rawChannel = await marshaller.serializers.channels.deserialize(channel);
      marshaller.cache.put(channel.id, rawChannel);
    }

    dispatch(event: MineralEvent.serverChannelPinsUpdate, params: [server, channel, timestamps]);
  }
}
