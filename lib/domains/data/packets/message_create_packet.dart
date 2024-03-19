import 'package:mineral/api/private/user.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    switch (message.payload['guild_id']) {
      case String():
        await sendServerMessage(dispatch, message.payload);
      default:
        sendPrivateMessage(dispatch, message.payload);
    }
  }

  Future<void> sendServerMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.serializers.serverMessage.serialize(json);
    dispatch(event: MineralEvent.serverMessageCreate, params: [message]);

    await marshaller.cache.put(message.id, json);
  }

  void sendPrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) {
    final message = marshaller.serializers.privateMessage.serialize(json);
    dispatch(event: MineralEvent.privateMessageCreate, params: [message]);
  }
}
