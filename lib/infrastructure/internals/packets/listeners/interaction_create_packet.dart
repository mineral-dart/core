import 'package:collection/collection.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class InteractionCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.interactionCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  InteractionCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final interactions = [
      ioc.resolve<CommandInteractionManagerContract>(),
    ];

    final interaction = interactions.firstWhereOrNull((interaction) => interaction.dispatcher.type.value == message.payload['type']);
    if (interaction == null) {
      ioc.resolve<LoggerContract>().warn('Interaction type ${message.payload['type']} not found');
      return;
    }

    await interaction.dispatcher.dispatch(message.payload);
  }
}
