import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerTextChannelFactory implements ChannelFactoryContract<ServerTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  Future<ServerTextChannel> serializeRemote(
      MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeRemote(marshaller, json);

    return ServerTextChannel(properties);
  }

  @override
  Future<ServerTextChannel> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerTextChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(
      MarshallerContract marshaller, ServerTextChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map(
        (element) async => marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'type': channel.type.value,
      'name': channel.name,
      'position': channel.position,
      'guild_id': channel.guildId,
      'topic': channel.description,
      'permission_overwrites': permissions,
      'parent_id': channel.categoryId,
    };
  }
}
