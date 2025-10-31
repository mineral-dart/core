import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelUpdate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawBeforeChannel = await _marshaller.cache?.get(
      message.payload['id'],
    );
    final before = rawBeforeChannel != null
        ? await _marshaller.serializers.channels.serialize(rawBeforeChannel)
        : null;

    final rawChannel = await _marshaller.serializers.channels.normalize(
      message.payload,
    );
    final channel = await _marshaller.serializers.channels.serialize(
      rawChannel,
    );

    return switch (channel) {
      ServerChannel() => dispatch(
          event: Event.serverChannelUpdate,
          params: [before, channel],
        ),
      PrivateChannel() => dispatch(
          event: Event.privateChannelUpdate,
          params: [before, channel],
        ),
      _ => _logger.warn(
          "Unknown channel type: $channel contact Mineral's core team.",
        )
    };
  }
}
