import 'dart:convert';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.ready;

  final LoggerContract logger;
  final MemoryStorageContract storage;

  const ReadyPacket(this.logger, this.storage);

  @override
  void listen(ShardMessage message, Function({required String event, required List params}) dispatch) {
    final client = Bot.fromJson(message.payload);

    logger.trace(jsonEncode(message.payload));
    dispatch(event: event.toString(), params: [client]);
  }
}
