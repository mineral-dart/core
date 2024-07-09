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
    final server = await marshaller.serializers.server.serialize(message.payload);

    for (final role in server.roles.list.values) {
      role.server = server;
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    final CommandInteractionManagerContract interactionManager = ioc.resolve('commandInteractionManager');
    final Bot bot = ioc.resolve('bot');
    await interactionManager.registerServer(bot, server);

    dispatch(event: Event.serverCreate, params: [server]);
  }
}
