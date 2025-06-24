import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/bot/bot.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
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
    await List.from(message.payload['channels']).map((element) async {
      return _marshaller.serializers.channels.normalize({
        ...element,
        'guild_id': message.payload['id'],
      });
    }).wait;

    await List.from(message.payload['members']).map((element) async {
      return _marshaller.serializers.member.normalize({
        ...element,
        'guild_id': message.payload['id'],
      });
    }).wait;

    await List.from(message.payload['roles']).map((element) async {
      return _marshaller.serializers.role.normalize({
        ...element,
        'guild_id': message.payload['id'],
      });
    }).wait;

    await List.from(message.payload['stickers']).map((element) async {
      return _marshaller.serializers.sticker.normalize({
        ...element,
        'guild_id': message.payload['id'],
      });
    }).wait;

    final rawServer =
        await _marshaller.serializers.server.normalize(message.payload);
    final server = await _marshaller.serializers.server.serialize(rawServer);

    final bot = ioc.resolve<Bot>();

    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    await interactionManager.registerServer(bot, server);

    dispatch(event: Event.serverCreate, params: [server]);
  }
}
