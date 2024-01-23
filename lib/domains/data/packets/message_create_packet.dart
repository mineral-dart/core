import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.messageCreate;

  final LoggerContract logger;
  final MemoryStorageContract storage;

  const MessageCreatePacket(this.logger, this.storage);

  @override
  void listen(
      ShardMessage message, Function({required String event, required List params}) dispatch) {
    switch (message.payload['guild_id']) {
      case String():
        sendServerMessage(dispatch, message.payload);
      default:
        User user = User.fromJson(message.payload['author']);
        sendPrivateMessage(dispatch, message.payload, user);
    }
  }

  void sendServerMessage(
      Function({required String event, required List params}) dispatch, Map<String, dynamic> json) {
    final message = ServerMessage.fromJson(server: storage.servers[json['guild_id']]!, json: json);
    dispatch(event: 'ServerMessageEvent', params: [message]);
  }

  void sendPrivateMessage(Function(InternalEventParams) dispatch, Map<String, dynamic> json, User user) {
    final message = PrivateMessage.fromJson(json: json, user: user);
    dispatch(InternalEventParams('PrivateMessageEvent', [message]));
  }
}
