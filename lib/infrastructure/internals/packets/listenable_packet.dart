import 'dart:async';

import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

typedef DispatchEvent = Function(
    {required Event event,
    required List params,
    bool Function(String?)? constraint});

abstract interface class ListenablePacket<T> {
  PacketType get packetType;

  FutureOr<void> listen(ShardMessage message, DispatchEvent dispatch);
}
