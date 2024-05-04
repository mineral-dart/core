import 'dart:async';

import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

typedef DispatchEvent = Function({required EventList event, required List params});

abstract interface class ListenablePacket<T> {
  PacketType get packetType;

  FutureOr<void> listen(
      ShardMessage message, DispatchEvent dispatch);
}
