import 'dart:convert';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.ready;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ReadyPacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final client = Bot.fromJson(message.payload);

    logger.trace(jsonEncode(message.payload));
    dispatch(event: MineralEvent.ready, params: [client]);
  }
}
