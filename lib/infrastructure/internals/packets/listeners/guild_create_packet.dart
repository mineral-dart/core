import 'package:mineral/api/common/bot.dart';
import 'package:mineral/domains/commands/command_interaction_manager.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawServer = await marshaller.serializers.server.normalize(message.payload);
    final server = await marshaller.serializers.server.serialize(rawServer);

    final bot = ioc.resolve<Bot>();

    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    await interactionManager.registerServer(bot, server);

    dispatch(event: Event.serverCreate, params: [server]);
  }
}
