import 'dart:convert';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

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
    ioc.bind('bot', () => bot);
    final CommandInteractionManagerContract interactionManager = ioc.resolve('commandInteractionManager');

    logger.trace(jsonEncode(message.payload));

    if(!isAlreadyUsed) {
      await interactionManager.registerGlobal(bot);
      isAlreadyUsed = true;
    }

    dispatch(event: Event.ready, params: [bot]);
  }
}
