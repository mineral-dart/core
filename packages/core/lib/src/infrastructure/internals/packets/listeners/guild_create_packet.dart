import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/bot/bot.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload as Map<String, dynamic>;
    await List.from(payload['channels'] as Iterable<dynamic>).map((element) async {
      return _marshaller.serializers.channels.normalize({
        ...(element as Map<String, dynamic>),
        'guild_id': payload['id'],
      });
    }).wait;

    await List.from(payload['members'] as Iterable<dynamic>).map((element) async {
      return _marshaller.serializers.member.normalize({
        ...(element as Map<String, dynamic>),
        'guild_id': payload['id'],
      });
    }).wait;

    await List.from(payload['roles'] as Iterable<dynamic>).map((element) async {
      return _marshaller.serializers.role.normalize({
        ...(element as Map<String, dynamic>),
        'guild_id': payload['id'],
      });
    }).wait;

    await List.from(payload['stickers'] as Iterable<dynamic>).map((element) async {
      return _marshaller.serializers.sticker.normalize({
        ...(element as Map<String, dynamic>),
        'guild_id': payload['id'],
      });
    }).wait;

    await List.from(payload['voice_states'] as Iterable<dynamic>).map((element) async {
      return _marshaller.serializers.voice.normalize({
        ...(element as Map<String, dynamic>),
        'guild_id': payload['id'],
      });
    }).wait;

    final rawServer =
        await _marshaller.serializers.server.normalize(payload);
    final server = await _marshaller.serializers.server.serialize(rawServer);

    final bot = ioc.resolve<Bot>();

    final interactionManager = ioc.resolve<CommandInteractionManagerContract>();
    await interactionManager.registerServer(bot, server);

    dispatch(event: Event.serverCreate, payload: (server: server));
  }
}
