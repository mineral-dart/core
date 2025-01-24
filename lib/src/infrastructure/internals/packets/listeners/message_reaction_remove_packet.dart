import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class MessageReactionRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageReactionRemove;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final raw = await _marshaller.serializers.reaction.normalize(message.payload);
    final reaction = await _marshaller.serializers.reaction.serialize(raw);

    final serverId = Snowflake.nullable(message.payload['guild_id']);
    final event = switch(serverId) {
      String() => Event.serverMessageReactionRemove,
      null => Event.privateMessageReactionRemove,
    };

    dispatch(event: event, params: [reaction]);
  }
}
