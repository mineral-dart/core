import 'dart:async';

import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

abstract interface class ListenablePacket<T> {
  PacketType get event;

  FutureOr<void> listen(
      ShardMessage message, Function({required String event, required List params}) dispatch);
}
