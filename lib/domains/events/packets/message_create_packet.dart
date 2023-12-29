import 'package:mineral/domains/events/internal_event_params.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get type => PacketType.messageCreate;

  @override
  void listen(Map<String, dynamic> payload) {
    final { 'message': ShardMessage message, 'dispatch': Function(InternalEventParams) dispatch } = payload;
    dispatch(InternalEventParams('$type', []));
  }
}
