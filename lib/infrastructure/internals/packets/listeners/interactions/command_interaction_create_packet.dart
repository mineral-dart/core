import 'package:collection/collection.dart';
import 'package:mineral/api/common/types/interaction_type.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class CommandInteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  CommandInteractionCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    final type = InteractionType.values
        .firstWhereOrNull((e) => e.value == message.payload['type']);

    if (type == InteractionType.applicationCommand) {
      await interactionManager.dispatcher.dispatch(message.payload);
    }
  }
}
