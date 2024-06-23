import 'package:mineral/infrastructure/interaction/interaction_manager.dart';
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
    final InteractionManagerContract interactionManager = InteractionManager.singleton();
    await interactionManager.dispatcher.dispatch(message.payload);
  }
}
