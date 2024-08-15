import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerCategoryChannelFactory implements ChannelFactoryContract<ServerCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  Future<ServerCategoryChannel> serializeRemote(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeRemote(marshaller, json);
    return ServerCategoryChannel(properties);
  }

  @override
  Future<ServerCategoryChannel> serializeCache(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeRemote(marshaller, json);
    return ServerCategoryChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerCategoryChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async =>
        marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

    return {
      'id': channel.id.value,
      'name': channel.name,
      'type': channel.type.value,
      'position': channel.position,
      'permission_overwrites': permissions,
      'guild_id': channel.guildId,
    };
  }
}
