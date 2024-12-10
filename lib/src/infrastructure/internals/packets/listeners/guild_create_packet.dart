import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/bot.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawServer =
        await _marshaller.serializers.server.normalize(message.payload);

    final server = await _marshaller.serializers.server.serialize(rawServer);

    final bot = ioc.resolve<Bot>();

    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    await interactionManager.registerServer(bot, server);

    dispatch(event: Event.serverCreate, params: [server]);
  }
}
