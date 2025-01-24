import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/message_type.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    final payload = await _marshaller.serializers.message.normalize(message.payload);
    final serializedMessage = await _marshaller.serializers.message.serialize(payload);

    final serverId = Snowflake.nullable(message.payload['guild_id']);
    final event = switch (serverId) {
      String() => Event.serverMessageCreate,
      Null() => Event.privateMessageCreate,
    };

    dispatch(event: event, params: [serializedMessage]);
  }
}
