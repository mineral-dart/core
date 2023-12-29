import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.messageCreate;

  @override
  void listen(Map<String, dynamic> payload) {
    final { 'message': ShardMessage message, 'dispatch': Function(InternalEventParams) dispatch } = payload;
    dispatch(InternalEventParams(event.toString(), []));
  }
}
