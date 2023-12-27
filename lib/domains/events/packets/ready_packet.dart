import 'dart:async';

import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get type => PacketType.ready;

  @override
  void listen(Map<String, dynamic> payload) {
    final { 'message': ShardMessage message, 'dispatch': Function(Map<String, dynamic>) dispatch } = payload;
    dispatch({'event': type.toString(), 'params': ['test']});
  }
}
