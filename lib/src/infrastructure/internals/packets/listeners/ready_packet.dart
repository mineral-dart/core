import 'package:mineral/src/api/common/bot/bot.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ReadyPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.ready;

  bool isAlreadyUsed = false;

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final bot = ioc.make<Bot>(() => Bot.fromJson(message.payload));
    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();

    if (!isAlreadyUsed) {
      await interactionManager.registerGlobal(bot);
      isAlreadyUsed = true;
    }

    dispatch(event: Event.ready, params: [bot]);
  }
}
