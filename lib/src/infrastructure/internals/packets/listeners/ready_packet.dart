import 'dart:convert';

import 'package:mineral/src/api/common/bot.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.ready;

  final LoggerContract logger;
  final MarshallerContract marshaller;
  bool isAlreadyUsed = false;

  ReadyPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final bot = Bot.fromJson(message.payload);
    ioc.bind(Bot, () => bot);
    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();

    logger.trace(jsonEncode(message.payload));

    if (!isAlreadyUsed) {
      await interactionManager.registerGlobal(bot);
      isAlreadyUsed = true;
    }

    dispatch(event: Event.ready, params: [bot]);
  }
}