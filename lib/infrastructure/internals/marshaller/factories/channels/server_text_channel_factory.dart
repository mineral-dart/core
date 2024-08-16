import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/channel_factory.dart';

final class ServerTextChannelFactory implements ChannelFactoryContract<ServerTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  Future<void> normalize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'type': json['type'],
      'position': json['position'],
      'name': json['name'],
      'description': json['topic'],
      'guild_id': json['guild_id'],
      'parent_id': json['parent_id'],
      'permission_overwrites': json['permission_overwrites'],
    };

    final cacheKey = marshaller.cacheKey.channel(json['id']);
    await marshaller.cache.put(cacheKey, payload);
  }

  @override
  Future<ServerTextChannel> serialize(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final properties = await ChannelProperties.serializeCache(marshaller, json);
    return ServerTextChannel(properties);
  }

  @override
  Future<Map<String, dynamic>> deserialize(MarshallerContract marshaller, ServerTextChannel channel) async {
    final permissions = await Future.wait(channel.permissions.map((element) async => marshaller.serializers.channelPermissionOverwrite.deserialize(element)));

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
