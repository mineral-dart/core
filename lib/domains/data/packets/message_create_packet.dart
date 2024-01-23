import 'package:mineral/api/private/private_message.dart';
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
  void listen(ShardMessage message, DispatchEvent dispatch) {
    switch (message.payload['guild_id']) {
      case String():
        sendServerMessage(dispatch, message.payload);
      default:
        User user = User.fromJson(message.payload['author']);
        sendPrivateMessage(dispatch, message.payload, user);
    }
  }

  void sendServerMessage(DispatchEvent dispatch, Map<String, dynamic> json) {
    final message = marshaller.serializers.serverMessage.serialize(json);
    dispatch(event: MineralEvent.serverMessageCreate, params: [message]);
  }

  void sendPrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json, User user) {
    final message = PrivateMessage.fromJson(json: json, user: user);
    dispatch(event: MineralEvent.serverMessageCreate, params: [message]); // todo
  }
}
